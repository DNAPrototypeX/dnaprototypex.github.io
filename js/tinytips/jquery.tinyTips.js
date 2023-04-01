/***********************************************************/
/*                    tinyTips Plugin                      */
/*                      Version: 1.0                       */
/*                      Mike Merritt                       */
/*                 Updated: Feb 4th, 2010                  */
/***********************************************************/

(function($){  
	$.fn.tinyTips = function (supCont) {
		// it must have a div with the class "content" somewhere inside of it.
		var tipFrame = '<div class="tinyTip"><div class="content"></div><div class="bottom">&nbsp;</div></div>';
		// Speed of the animations in milliseconds - 1000 = 1 second.
		var animSpeed = 300;

		// Global tinyTip variable;
		var tinyTip;
		var tText;

		// When we hover over the element that we want the tooltip applied to
		$(this).hover(function() {
			
			// Inject the markup for the tooltip into the page and
			// set the tooltip global to the current markup and then hide it.
			$('body').append(tipFrame);
			tinyTip = $('div.tinyTip');
			tinyTip.hide();
			
			var theId = $(this).attr('id');
			var tipCont = $('span.'+theId).html();

			$('.tinyTip .content').html(tipCont);
			/*
			tText = $(this).attr('title');
			$(this).attr('title', '');
			*/
			// vire le titre
			$(this).attr('title', '');
			
			var yOffset = tinyTip.height() + 17;
			var xOffset = (((tinyTip.width() - 10) / 2)) - ($(this).width() / 2);
			var pos = $(this).offset();
			var nPos = pos;
			nPos.top = pos.top - yOffset;
			nPos.left = pos.left - xOffset;
			tinyTip.css('position', 'absolute').css('z-index', '1000');
			tinyTip.css(nPos).fadeIn(animSpeed);
		}, function() {
			//$(this).attr('title', tText);
			// Fade the tooltip out once the mouse moves away and then remove it from the DOM.
			$('div.tinyTip').fadeOut(animSpeed, function() {
				$(this).remove();
			});
			
		});
		
	}

})(jQuery);