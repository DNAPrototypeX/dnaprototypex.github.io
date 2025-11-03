
// darkmode-toggle.js

document.addEventListener('DOMContentLoaded', () => {
  const toggleButton = document.getElementById('darkModeToggle');

  // Load saved theme from localStorage or default to light
  if (localStorage.getItem('theme') === 'dark') {
    document.body.classList.add('dark-mode');
  }

  toggleButton.addEventListener('click', (event) => {
    event.preventDefault();
    document.body.classList.toggle('dark-mode');

    // Save preference
    if (document.body.classList.contains('dark-mode')) {
      localStorage.setItem('theme', 'dark');
    } else {
      localStorage.setItem('theme', 'light');
    }
  });
});

// js/blog-loader.js
async function loadBlogPosts() {
  const blogSection = document.getElementById('blog');
  if (!blogSection) return;

  const response = await fetch('blog/posts.json');
  const posts = await response.json();

posts.sort(async (a, b) => {
  const [aHtml, bHtml] = await Promise.all([fetch(a.path).then(r => r.text()), fetch(b.path).then(r => r.text())]);
  const aDate = new Date(new DOMParser().parseFromString(aHtml, 'text/html').querySelector('meta[name="date"]')?.content || 0);
  const bDate = new Date(new DOMParser().parseFromString(bHtml, 'text/html').querySelector('meta[name="date"]')?.content || 0);
  return bDate - aDate;
});
  
  const MAX_PREVIEW_LENGTH = 150; // characters to show in preview

  for (const post of posts) {
    try {
      const res = await fetch(post.path);
      const html = await res.text();
      const doc = new DOMParser().parseFromString(html, 'text/html');

      const title = doc.querySelector('h2')?.innerText || 'Untitled Post';
      const firstParagraph = doc.querySelector('p')?.innerText || '';
      const date = doc.querySelector('meta[name="date"]')?.content || 'Unknown Date';
      const preview = doc.querySelector('meta[name="description"]')?.content || firstParagraph.length > MAX_PREVIEW_LENGTH
        ? firstParagraph.substring(0, MAX_PREVIEW_LENGTH).trim() + '...'
        : firstParagraph;

      const postEl = document.createElement('section');
      postEl.className = 'news-item';
      postEl.onclick = () => window.location.href = post.path;

      postEl.innerHTML = `
        <h3>${title}</h3>
        <p>${preview}</p>
        <div class="date">${new Date(date).toLocaleDateString(undefined, {
          year: 'numeric',
          month: 'long',
          day: 'numeric'
        })}</div>
      `;

      blogSection.appendChild(postEl);
    } catch (err) {
      console.error('Error loading post:', post.path, err);
    }
  }
}

document.addEventListener('DOMContentLoaded', loadBlogPosts);
