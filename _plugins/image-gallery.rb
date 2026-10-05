# frozen_string_literal: true
#
# Auto-tiling image galleries.
#
# Kramdown puts every image in its own <p>, and block-level paragraphs can
# never sit side by side no matter what CSS you hang off the <img>. This hook
# rewrites runs of image-only paragraphs into a single flex container so the
# stylesheet can justify them into rows.
#
# Each image also gets its true display aspect ratio as a `--ar` custom
# property. Dimensions are read from the file on disk with the EXIF orientation
# applied, so a phone photo stored 4000x3000 but flagged as rotated is measured
# as portrait -- which is what the browser draws. That is what makes the sizing
# automatic: the layout knows each image's real shape, so nothing needs to be
# labelled .img-half or .img-third by hand.
#
# Videos from Chirpy's embed/video.html include tile the same way. Their shape
# comes from the MP4 track header, with the rotation matrix applied, so a phone
# video recorded sideways is measured as portrait too.

module ImageGallery
  # Used when dimensions can't be read (remote src, unreadable file). A mild
  # landscape ratio degrades to a reasonable-looking row rather than a broken one.
  FALLBACK_RATIO = 1.5

  # Chirpy's own float/width helpers position an image deliberately. A paragraph
  # holding one of these opts out of tiling entirely.
  OPT_OUT_CLASSES = %w[left right normal shadow w-50 w-75].freeze

  # Sizing classes this hook replaces; stripped so they can't fight the gallery.
  LEGACY_CLASSES = %w[img-half img-third].freeze

  # One image link plus the optional <em> caption Chirpy renders beneath it.
  IMG_UNIT = %r{<a[^>]*\bimg-link\b[^>]*>\s*<img\b[^>]*>\s*</a>(?:\s*<em>.*?</em>)?}m

  # One embedded video plus the optional <em> caption from the include's title.
  VIDEO_UNIT = %r{<video\b[^>]*>.*?</video>(?:\s*<em>.*?</em>)?}m

  MEDIA_UNIT = %r{(?:#{IMG_UNIT}|#{VIDEO_UNIT})}m

  # A paragraph containing images, videos and captions and nothing else. The
  # video include's paragraph can carry an IAL class such as .vid.
  PARAGRAPH = %r{<p(?:\s[^>]*)?>\s*(?:#{MEDIA_UNIT}\s*(?:<br\s*/?>)?\s*)+</p>}m

  # One or more such paragraphs in a row -- the unit we replace.
  RUN = %r{#{PARAGRAPH}(?:\s*#{PARAGRAPH})*}m

  UNIT_SCAN = %r{
    (<a[^>]*\bimg-link\b[^>]*>\s*<img\b([^>]*)>\s*</a>|<video\b[^>]*>(.*?)</video>)
    (\s*<em>.*?</em>)?
  }mx

  # Boxes that hold the track headers, on the way down from the file root.
  MP4_CONTAINERS = %w[moov trak].freeze

  class << self
    def process(html, site)
      return html unless html.include?('img-link') || html.include?('<video')

      html.gsub(RUN) do |run|
        next run if OPT_OUT_CLASSES.any? { |c| run.match?(/\bclass="[^"]*\b#{c}\b[^"]*"/) }

        items = run.scan(UNIT_SCAN)
        next run if items.empty?

        build_gallery(items, site)
      end
    end

    private

    def build_gallery(items, site)
      figures = items.map do |media, img_attrs, video_inner, caption|
        attrs = img_attrs || video_inner[/<source\b[^>]*>/].to_s
        ratio = ratio_for(attrs, site)
        tag = media.start_with?('<video') ? annotate_video(media, ratio) : annotate(media, ratio)
        %(<div class="gallery-item" style="--ar:#{format('%.4f', ratio)}">#{tag}#{caption}</div>)
      end

      modifier = items.size == 1 ? ' gallery--single' : ''
      %(<div class="gallery#{modifier}">#{figures.join}</div>)
    end

    # Strips the retired sizing classes and stamps on intrinsic width/height,
    # which lets the browser reserve the right space before the image loads.
    def annotate(link, ratio)
      link = link.gsub(/\s*\bclass="([^"]*)"/) do
        kept = Regexp.last_match(1).split(/\s+/) - LEGACY_CLASSES
        kept.empty? ? '' : %( class="#{kept.join(' ')}")
      end

      return link if link.match?(/<img[^>]*\bwidth=/)

      width = 1000
      height = (width / ratio).round
      link.sub(/<img\b/, %(<img width="#{width}" height="#{height}"))
    end

    # Same intrinsic size hint as annotate, for a <video> element.
    def annotate_video(video, ratio)
      return video if video.match?(/<video[^>]*\bwidth=/)

      width = 1000
      height = (width / ratio).round
      video.sub(/<video\b/, %(<video width="#{width}" height="#{height}"))
    end

    def ratio_for(attrs, site)
      src = attrs[/\bsrc="([^"]*)"/, 1]
      return FALLBACK_RATIO if src.nil?

      path = local_path(src, site)
      return FALLBACK_RATIO if path.nil?

      cache[path] ||= begin
        dims = dimensions(path)
        dims ? dims[0].to_f / dims[1] : FALLBACK_RATIO
      end
    end

    def cache
      @cache ||= {}
    end

    def local_path(src, site)
      return nil if src.start_with?('http://', 'https://', '//', 'data:')

      relative = src.sub(%r{\A#{Regexp.escape(site.baseurl.to_s)}}, '').sub(%r{\A/}, '')
      path = File.join(site.source, relative)
      File.file?(path) ? path : nil
    end

    # Returns [width, height] as the browser will draw them, or nil.
    def dimensions(path)
      File.open(path, 'rb') do |io|
        case File.extname(path).downcase
        when '.jpg', '.jpeg' then jpeg_dimensions(io)
        when '.png'          then png_dimensions(io)
        when '.gif'          then gif_dimensions(io)
        when '.mp4', '.m4v', '.mov' then mp4_dimensions(io, io.size)
        end
      end
    rescue StandardError => e
      Jekyll.logger.warn 'ImageGallery:', "could not size #{path}: #{e.message}"
      nil
    end

    def png_dimensions(io)
      header = io.read(24).to_s
      return nil unless header.bytesize == 24 && header[1, 3] == 'PNG'

      header[16, 8].unpack('N2')
    end

    def gif_dimensions(io)
      header = io.read(10).to_s
      return nil unless header.start_with?('GIF')

      header[6, 4].unpack('v2')
    end

    # Walks the MP4 box tree down to the first track header with a picture
    # size. Audio tracks report 0x0, so they are skipped on the way past.
    def mp4_dimensions(io, finish)
      while io.pos + 8 <= finish
        start = io.pos
        size, type = io.read(8).unpack('Na4')
        header = 8

        if size == 1
          size = io.read(8).unpack1('Q>')
          header = 16
        elsif size.zero?
          size = finish - start
        end
        return nil if size < header

        if MP4_CONTAINERS.include?(type)
          dims = mp4_dimensions(io, start + size)
          return dims if dims
        elsif type == 'tkhd'
          dims = tkhd_dimensions(io.read(size - header).to_s)
          return dims if dims
        end

        io.seek(start + size)
      end

      nil
    end

    # Reads the 16.16 fixed-point width and height after the transform matrix.
    # A matrix with a zero first term is a quarter turn, so the drawn shape is
    # transposed -- the video equivalent of EXIF orientations 5-8.
    def tkhd_dimensions(box)
      matrix_at = box.getbyte(0) == 1 ? 52 : 40
      return nil if box.bytesize < matrix_at + 44

      a, b = box[matrix_at, 8].unpack('l>2')
      width, height = box[matrix_at + 36, 8].unpack('N2').map { |v| v >> 16 }
      return nil if width.zero? || height.zero?

      a.zero? && !b.zero? ? [height, width] : [width, height]
    end

    # Walks the JPEG marker segments for the SOF frame header, noting the EXIF
    # orientation on the way past so rotated photos report their drawn shape.
    def jpeg_dimensions(io)
      return nil unless io.read(2) == "\xFF\xD8".b

      orientation = 1

      loop do
        byte = io.read(1)
        return nil if byte.nil?
        next unless byte == "\xFF".b

        marker = io.read(1)
        return nil if marker.nil?

        code = marker.ord
        # Padding, and standalone markers that carry no length field.
        next if code == 0xFF || code == 0x01 || (0xD0..0xD9).cover?(code)

        length = io.read(2)&.unpack1('n')
        return nil if length.nil? || length < 2

        if sof?(code)
          frame = io.read(5)
          return nil if frame.nil? || frame.bytesize < 5

          height, width = frame[1, 4].unpack('n2')
          return nil if width.nil? || height.nil? || width.zero? || height.zero?

          # Orientations 5-8 are the quarter turns; drawn shape is transposed.
          return (5..8).cover?(orientation) ? [height, width] : [width, height]
        elsif code == 0xE1
          # APP1 also carries XMP, which phones often write after the EXIF
          # block. Only an EXIF segment may set the orientation, or the XMP
          # one would reset it to upright.
          segment = io.read(length - 2).to_s
          orientation = exif_orientation(segment) if segment.start_with?("Exif\0\0")
        else
          io.seek(length - 2, IO::SEEK_CUR)
        end
      end
    end

    # Frame headers, excluding the entropy-coding tables that share the range.
    def sof?(code)
      (0xC0..0xCF).cover?(code) && ![0xC4, 0xC8, 0xCC].include?(code)
    end

    def exif_orientation(segment)
      return 1 unless segment.start_with?("Exif\0\0")

      tiff = segment[6..].to_s
      return 1 if tiff.bytesize < 8

      little = tiff[0, 2] == 'II'
      short = little ? 'v' : 'n'
      long = little ? 'V' : 'N'

      offset = tiff[4, 4].unpack1(long)
      return 1 if offset.nil? || offset + 2 > tiff.bytesize

      count = tiff[offset, 2].unpack1(short).to_i

      count.times do |i|
        entry = tiff[offset + 2 + (i * 12), 12]
        break if entry.nil? || entry.bytesize < 12
        next unless entry[0, 2].unpack1(short) == 0x0112

        value = entry[8, 2].unpack1(short)
        return value.between?(1, 8) ? value : 1
      end

      1
    end
  end
end

Jekyll::Hooks.register %i[posts pages documents], :post_render do |doc|
  next unless doc.output_ext == '.html'

  doc.output = ImageGallery.process(doc.output, doc.site)
end
