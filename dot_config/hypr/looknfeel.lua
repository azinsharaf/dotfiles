-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- Switch to scrolling layout for ultrawide-friendly centered columns.
hl.config({
  general = {
    layout = "scrolling",
  },
})

hl.config({
  decoration = {
    active_opacity = 0.9,
    inactive_opacity = 0.95,
  },
})

hl.config({
  layout = {
    -- Still constrain a lone window to a sensible aspect ratio.
    single_window_aspect_ratio = { 16, 9 },
  },
})

hl.config({
  scrolling = {
    -- Each column is 45% of screen width.
    -- 1 window  = 45% width (centered)
    -- 2 windows = 90% width total (centered as a pair)
    -- 3+ windows = scroll horizontally.
    column_width = 0.45,
  },
})

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })
