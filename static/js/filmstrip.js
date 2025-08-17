document.addEventListener('DOMContentLoaded', function () {
  const hero = document.getElementById('hero');
  const strip = document.getElementById('filmstrip');
  if (!hero || !strip) return;

  strip.addEventListener('click', function (e) {
    const a = e.target.closest('a.thumb');
    if (!a) return;
    e.preventDefault();

    // swap hero image
    const full = a.dataset.full;
    const w = parseInt(a.dataset.w || '0', 10);
    const h = parseInt(a.dataset.h || '0', 10);
    if (full) hero.src = full;
    if (w && h) { hero.width = w; hero.height = h; }

    // update active state
    strip.querySelectorAll('a.thumb.active').forEach(el => el.classList.remove('active'));
    a.classList.add('active');
  }, { passive: false });
});

