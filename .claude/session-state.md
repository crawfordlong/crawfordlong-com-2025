# OBJECTIVE
Homepage gallery: Masonry.js (no reflow on append) + month/year markers in left gutter.

# PLAN
1. [x] Masonry + imagesLoaded + InfiniteScroll outlayer integration.
2. [x] CSS: 320px cards, .grid-sizer, mobile 100%.
3. [x] Wrap masonry in inner <div> so fitWidth respects main's 1200px maxw.
4. [x] Month markers: data-ym on each card; placeMarkers() runs on layoutComplete; absolute-positioned in <main>'s left gutter; year-change variant bigger; hidden ≤700px.
5. [ ] User verifies in browser: 3 cols centered, markers in left gutter at month boundaries, year change visibly larger, append doesn't reflow.
6. [ ] Optional follow-up: sticky/fixed-overlay current-month indicator (separate from in-page markers).

# STATUS
Markers ship as: lowercase 3-letter month + 4-digit year (e.g. "mar 2026"); font-weight 800; opacity 0.5; year-change at 1.5rem vs 0.95rem default. Anchored to first DOM card of each new month (DOM is desc by date, so as you scroll down, months go backwards). placeMarkers() removes-then-rebuilds on every layoutComplete — handles initial layout, post-imagesLoaded relayout, and InfiniteScroll appends.

# DECISIONS
- Masonry+imagesLoaded+InfiniteScroll@5 (Metafizzy); outlayer:msnry handles append+layout.
- fitWidth:true requires constrained parent → wrapper div.
- Markers absolute-positioned (incompatible with position:sticky); sticky pin would be a separate fixed overlay if requested.
- Marker positioning in <main> (not inside .masonry) so they live in the 1180-980=~100px gutter.

# WORKING SET
- layouts/index.html:13-14, 55-56 (wrapper), 24/39/50 (data-ym attrs), 76-118 (init + placeMarkers)
- static/css/main.css:22-27 (main position:relative), 28-42 (masonry/grid-sizer/card), 44-67 (.month-marker)
- :root --gap=10px, --maxw=1200px
