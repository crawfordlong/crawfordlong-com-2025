# OBJECTIVE
Swap homepage gallery from CSS multi-column to Masonry.js so infinite-scroll appends don't reflow already-rendered cards.

# PLAN
1. [x] layouts/index.html: masonry-layout + imagesloaded scripts; .grid-sizer; Masonry + InfiniteScroll outlayer init.
2. [x] static/css/main.css: drop column-* rules; pin .card to 320px (100% ≤700px); matching .grid-sizer rule.
3. [x] Wrap masonry in inner div inside <main> — fitWidth was reading body width and stamping inline width on main, breaking max-width and forcing 4 cols.
4. [ ] User verifies in browser: 3 cols at default viewport, centered, infinite scroll appends without reflow.

# STATUS
Live build showed (a) too wide, (b) 4 cols. Root cause: <main> was both layout box and Masonry container; with fitWidth:true Masonry sized off body width, not the 1200px maxw, and stamped an inline width onto main. Fix: inner `<div class="masonry">` so Masonry's parent is the 1180px content box. Math: 3×320 + 2×10 = 980 fits; 4 cols = 1310 doesn't. Awaiting user re-verify after Cloudflare rebuild.

# DECISIONS
- masonry-layout + imagesloaded + infinite-scroll@5 (Metafizzy).
- outlayer: msnry on InfiniteScroll handles imagesLoaded + masonry.appended() automatically.
- .grid-sizer (not fixed px) so mobile media query can swap to 100% width.
- fitWidth: true to center the grid; requires constrained parent — hence wrapper div.

# WORKING SET
- layouts/index.html:13-14, 55-56 (wrapper div), 76-104 (init script)
- static/css/main.css:28-42 (.masonry, .grid-sizer, .card, mobile)
- :root --gap=10px (gutter), --maxw=1200px
