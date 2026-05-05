# OBJECTIVE
Swap the homepage gallery from CSS multi-column layout to Masonry.js so appended (infinite-scroll) batches don't reflow already-rendered cards.

# PLAN
1. [ ] Update `layouts/index.html`: add masonry-layout + imagesloaded scripts; add `.grid-sizer`; replace init JS with Masonry + InfiniteScroll `outlayer` integration.
2. [ ] Update `static/css/main.css`: remove `column-width`/`column-gap` from `.masonry`; pin `.card` to 320px (100% on mobile ≤700px); add matching `.grid-sizer` rule.
3. [ ] User verifies in browser (hugo server) that 3-col layout renders, infinite scroll appends without reflowing existing cards.

# STATUS
Decision locked: keep ~320px card width, 3 cols at default `--maxw: 1200px`. Year-marker feature is paused; image-order fix comes first.

# DECISIONS
- Library: masonry-layout + imagesloaded (Metafizzy, same author as the existing infinite-scroll@5).
- Use `outlayer: msnry` option on InfiniteScroll — handles imagesLoaded + masonry.appended() automatically.
- Use `.grid-sizer` element (not fixed pixel) so mobile media query can swap to 100% width.
- `fitWidth: true` to center the grid inside `main`.

# WORKING SET
- layouts/index.html (template + init script)
- static/css/main.css:28-37 (.masonry rules), 42-47 (.card)
- :root --gap = 10px (used as masonry gutter)

## Session ended cleanly: 2026-05-05T13:52:10Z
