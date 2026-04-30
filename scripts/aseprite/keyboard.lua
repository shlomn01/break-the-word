-- Generate pixel-art keyboard sprites in a clean light-gray style
-- (modeled on the user's reference image — rounded gray caps with dark icons).
-- Output: assets/sprites/key_left.png, key_right.png, key_space.png

local OUT = "../../assets/sprites/"
local function rgba(r,g,b,a) return app.pixelColor.rgba(r,g,b,a or 255) end

local C = {
  topHi  = rgba(252, 252, 252),  -- bright top edge
  top    = rgba(224, 224, 224),  -- light gray top face
  side   = rgba(168, 168, 168),  -- mid edge tone
  base   = rgba(120, 120, 120),  -- darker base / front lip
  bottom = rgba( 70,  70,  70),  -- under-key shadow
  border = rgba( 30,  30,  30),  -- dark outer border
  icon   = rgba( 30,  30,  30),  -- arrow / text icon
  iconLo = rgba( 80,  80,  80),  -- icon shading edge
}

-- Render a rounded key cap WxH with chamfered corners (1 px notches).
local function drawKeyCap(img, W, H)
  local baseDepth = 4
  local topH = H - baseDepth

  -- Top face fill
  for y = 0, topH - 1 do
    for x = 0, W - 1 do
      img:drawPixel(x, y, C.top)
    end
  end
  -- Front-lip face (bottom 4 rows): darker
  for y = topH, H - 1 do
    for x = 0, W - 1 do
      img:drawPixel(x, y, C.base)
    end
  end

  -- Outer border on all sides
  for x = 0, W - 1 do
    img:drawPixel(x, 0,     C.border)
    img:drawPixel(x, H - 1, C.border)
  end
  for y = 0, H - 1 do
    img:drawPixel(0,     y, C.border)
    img:drawPixel(W - 1, y, C.border)
  end

  -- Chamfer the four corners (1 transparent + 1 stair-step border)
  local CLEAR = app.pixelColor.rgba(0, 0, 0, 0)
  -- TL
  img:drawPixel(0, 0, CLEAR)
  img:drawPixel(1, 0, C.border); img:drawPixel(0, 1, C.border)
  -- TR
  img:drawPixel(W-1, 0, CLEAR)
  img:drawPixel(W-2, 0, C.border); img:drawPixel(W-1, 1, C.border)
  -- BL
  img:drawPixel(0, H-1, CLEAR)
  img:drawPixel(1, H-1, C.border); img:drawPixel(0, H-2, C.border)
  -- BR
  img:drawPixel(W-1, H-1, CLEAR)
  img:drawPixel(W-2, H-1, C.border); img:drawPixel(W-1, H-2, C.border)

  -- Top-edge highlight (bright row inside the border)
  for x = 2, W - 3 do
    img:drawPixel(x, 1, C.topHi)
  end
  for y = 2, topH - 2 do
    img:drawPixel(1, y, C.topHi)
  end

  -- Inner bevel: bottom-of-top-face shadow (sells the 3D depth)
  for x = 1, W - 2 do
    img:drawPixel(x, topH - 1, C.side)
  end
  for y = 1, topH - 2 do
    img:drawPixel(W - 2, y, C.side)
  end
end

local function blitMask(img, ox, oy, rows, color)
  for r = 1, #rows do
    for c = 1, #rows[r] do
      if rows[r]:sub(c, c) == "X" then
        img:drawPixel(ox + c - 1, oy + r - 1, color)
      end
    end
  end
end

-- ARROW glyphs: chunky, centered.
local LEFT_ARROW = {
  ".....X......",
  "....XX......",
  "...XXX......",
  "..XXXXXXXXX.",
  ".XXXXXXXXXX.",
  ".XXXXXXXXXX.",
  "..XXXXXXXXX.",
  "...XXX......",
  "....XX......",
  ".....X......",
}
local RIGHT_ARROW = {
  "......X.....",
  "......XX....",
  "......XXX...",
  ".XXXXXXXXX..",
  ".XXXXXXXXXX.",
  ".XXXXXXXXXX.",
  ".XXXXXXXXX..",
  "......XXX...",
  "......XX....",
  "......X.....",
}

-- 5x7 chunky letters for "SPACE"
local LETTERS = {
  S = { ".XXXX",
        "X....",
        "X....",
        ".XXX.",
        "....X",
        "....X",
        "XXXX." },
  P = { "XXXX.",
        "X...X",
        "X...X",
        "XXXX.",
        "X....",
        "X....",
        "X...." },
  A = { "..X..",
        ".X.X.",
        "X...X",
        "X...X",
        "XXXXX",
        "X...X",
        "X...X" },
  C = { ".XXXX",
        "X....",
        "X....",
        "X....",
        "X....",
        "X....",
        ".XXXX" },
  E = { "XXXXX",
        "X....",
        "X....",
        "XXX..",
        "X....",
        "X....",
        "XXXXX" },
}

-- Key sizes
local AW, AH = 32, 32             -- arrow keys
local SW, SH = 110, 32            -- spacebar (wider for "SPACE")

-- Left arrow key
do
  local s = Sprite(AW, AH, ColorMode.RGB)
  local img = s.cels[1].image
  drawKeyCap(img, AW, AH)
  -- Center the 12x10 arrow in the top-face area (32 - 4 base = 28 tall)
  local ox = math.floor((AW - 12) / 2)
  local oy = math.floor((AH - 4 - 10) / 2)
  blitMask(img, ox, oy, LEFT_ARROW, C.icon)
  s:saveCopyAs(OUT .. "key_left.png")
  s:close()
end

-- Right arrow key
do
  local s = Sprite(AW, AH, ColorMode.RGB)
  local img = s.cels[1].image
  drawKeyCap(img, AW, AH)
  local ox = math.floor((AW - 12) / 2)
  local oy = math.floor((AH - 4 - 10) / 2)
  blitMask(img, ox, oy, RIGHT_ARROW, C.icon)
  s:saveCopyAs(OUT .. "key_right.png")
  s:close()
end

-- Space key with "SPACE" text
do
  local s = Sprite(SW, SH, ColorMode.RGB)
  local img = s.cels[1].image
  drawKeyCap(img, SW, SH)

  -- Lay out "SPACE" centered.
  -- Each letter is 5 wide, with 2-px space between letters: 5*5 + 4*2 = 33 wide.
  local word = { "S", "P", "A", "C", "E" }
  local letterW, letterH, gap = 5, 7, 2
  local totalW = #word * letterW + (#word - 1) * gap
  local ox = math.floor((SW - totalW) / 2)
  local oy = math.floor((SH - 4 - letterH) / 2)
  for i, ch in ipairs(word) do
    blitMask(img, ox + (i - 1) * (letterW + gap), oy, LETTERS[ch], C.icon)
  end

  s:saveCopyAs(OUT .. "key_space.png")
  s:close()
end

print("OK: gray rounded keys generated (with SPACE label)")
