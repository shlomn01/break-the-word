-- Generate all visual sprites for the "Break the Word" game.
-- Outputs PNG files into ../../assets/sprites/

local OUT = "../../assets/sprites/"

-- Color helpers
local function rgba(r, g, b, a) return app.pixelColor.rgba(r, g, b, a or 255) end

-- Game palette (matches reference image's space-retro vibe)
local C = {
  bg_navy   = rgba(10, 8, 48),
  bg_deep   = rgba(5, 4, 22),
  border1   = rgba(106, 74, 184),   -- purple frame
  border2   = rgba(58, 40, 112),    -- darker purple
  panel     = rgba(14, 8, 40),
  star_w    = rgba(255, 240, 200),
  star_y    = rgba(255, 220, 120),
  galaxy_p  = rgba(255, 90, 138),   -- pink galaxy
  galaxy_v  = rgba(154, 74, 222),   -- violet
  saturn_b  = rgba(160, 74, 138),
  saturn_d  = rgba(122, 50, 112),
  saturn_h  = rgba(208, 106, 170),
  blue_b    = rgba(74, 106, 204),
  blue_d    = rgba(42, 74, 138),
  blue_h    = rgba(122, 154, 255),
  mountain  = rgba(42, 26, 90),
  mountain2 = rgba(58, 40, 122),
  brick_a   = rgba(255, 138, 61),   -- main orange
  brick_b   = rgba(255, 178, 90),   -- highlight
  brick_c   = rgba(180, 80, 30),    -- shadow
  brick_d   = rgba(120, 50, 20),    -- deep shadow
  ball_y    = rgba(216, 216, 54),
  ball_h    = rgba(255, 255, 128),
  ball_d    = rgba(170, 170, 48),
  ball_o    = rgba(20, 18, 0),
  ball_seam = rgba(255, 255, 255),
  paddle_r  = rgba(192, 48, 58),
  paddle_h  = rgba(255, 90, 90),
  paddle_d  = rgba(122, 26, 32),
  tape      = rgba(218, 218, 218),
  tape_h    = rgba(250, 250, 250),
  tape_d    = rgba(122, 122, 122),
  heart     = rgba(255, 74, 90),
  heart_d   = rgba(180, 30, 50),
  heart_e   = rgba(58, 36, 64),
  speaker_y = rgba(255, 217, 102),
  speaker_o = rgba(255, 90, 74),
  text_y    = rgba(255, 217, 102),
  text_o    = rgba(255, 138, 61),
}

-- Blit ASCII rows into image. palette is { ["X"] = color, ... }, "." = transparent.
local function blit(img, ox, oy, rows, palette)
  for y, row in ipairs(rows) do
    for x = 1, #row do
      local ch = row:sub(x, x)
      local c = palette[ch]
      if c then img:drawPixel(ox + x - 1, oy + y - 1, c) end
    end
  end
end

local function newSprite(w, h)
  local s = Sprite(w, h, ColorMode.RGB)
  return s, s.cels[1].image
end

local function save(s, name)
  s:saveCopyAs(OUT .. name)
  s:close()
end

----------------------------------------------------------------
-- 1. Ball (tennis ball, 5x5)
----------------------------------------------------------------
local function makeBall()
  local s, img = newSprite(7, 7)
  blit(img, 0, 0, {
    "..ooo..",
    ".oyyyo.",
    "ohYYYwo",
    "oyYYYyo",
    "oyyyyyo",
    ".oyyyo.",
    "..ooo..",
  }, {
    ["o"] = C.ball_o,
    ["y"] = C.ball_y,
    ["Y"] = C.ball_y,
    ["h"] = C.ball_h,
    ["w"] = C.ball_seam,
  })
  save(s, "ball.png")
end

----------------------------------------------------------------
-- 2. Paddle (28 wide x 4 tall, with tape ends)
----------------------------------------------------------------
local function makePaddle()
  local W, H = 28, 4
  local s, img = newSprite(W, H)
  for x = 0, W-1 do
    for y = 0, H-1 do
      local c
      if x < 5 or x >= W-5 then
        -- tape ends
        if y == 0 then c = C.tape_h
        elseif y == H-1 then c = C.tape_d
        else c = C.tape end
      else
        if y == 0 then c = C.paddle_h
        elseif y == H-1 then c = C.paddle_d
        else c = C.paddle_r end
      end
      img:drawPixel(x, y, c)
    end
  end
  save(s, "paddle.png")
end

----------------------------------------------------------------
-- 3. Saturn-style planet (22x12 with rings)
----------------------------------------------------------------
local function makeSaturn()
  local s, img = newSprite(22, 13)
  -- The body is a circle of r=4 centered at (11, 6)
  local cx, cy, r = 11, 6, 4
  for dy = -r, r do
    for dx = -r, r do
      local d2 = dx*dx + dy*dy
      if d2 <= r*r then
        local color = (d2 > (r-1)*(r-1)) and C.saturn_d or C.saturn_b
        img:drawPixel(cx + dx, cy + dy, color)
      end
    end
  end
  -- Highlight
  img:drawPixel(cx - 2, cy - 2, C.saturn_h)
  img:drawPixel(cx - 1, cy - 2, C.saturn_h)
  -- Rings: thin horizontal band
  for x = 0, 21 do
    if x < cx - 5 or x > cx + 5 then
      img:drawPixel(x, cy, C.saturn_d)
    end
  end
  -- Wider ring above/below body
  for x = 0, 21 do
    if x < cx - 6 or x > cx + 6 then
      img:drawPixel(x, cy - 1, C.saturn_b)
      img:drawPixel(x, cy + 1, C.saturn_b)
    end
  end
  save(s, "saturn.png")
end

----------------------------------------------------------------
-- 4. Blue planet (12x12)
----------------------------------------------------------------
local function makeBluePlanet()
  local s, img = newSprite(12, 12)
  local cx, cy, r = 6, 6, 5
  for dy = -r, r do
    for dx = -r, r do
      local d2 = dx*dx + dy*dy
      if d2 <= r*r then
        local color = (d2 > (r-1)*(r-1)) and C.blue_d or C.blue_b
        img:drawPixel(cx + dx, cy + dy, color)
      end
    end
  end
  -- Highlight
  img:drawPixel(cx - 2, cy - 2, C.blue_h)
  img:drawPixel(cx - 1, cy - 2, C.blue_h)
  img:drawPixel(cx - 2, cy - 1, C.blue_h)
  -- Surface markings
  img:drawPixel(cx + 1, cy + 1, C.blue_d)
  img:drawPixel(cx + 2, cy + 1, C.blue_d)
  img:drawPixel(cx + 1, cy + 2, C.blue_d)
  save(s, "blue_planet.png")
end

----------------------------------------------------------------
-- 5. Galaxy (decorative swirl, 28x14)
----------------------------------------------------------------
local function makeGalaxy()
  local s, img = newSprite(28, 14)
  -- Concentric oval-ish rings of colored pixels
  local cx, cy = 14, 7
  math.randomseed(42)
  for i = 1, 50 do
    local ang = math.random() * math.pi * 2
    local rad = 1 + math.random() * 6
    local rx = math.floor(cx + math.cos(ang) * rad * 1.6 + 0.5)
    local ry = math.floor(cy + math.sin(ang) * rad * 0.5 + 0.5)
    if rx >= 0 and rx < 28 and ry >= 0 and ry < 14 then
      local color = (math.random() < 0.5) and C.galaxy_p or C.galaxy_v
      img:drawPixel(rx, ry, color)
    end
  end
  -- Bright core
  img:drawPixel(cx, cy, C.star_w)
  img:drawPixel(cx-1, cy, C.galaxy_p)
  img:drawPixel(cx+1, cy, C.galaxy_p)
  save(s, "galaxy.png")
end

----------------------------------------------------------------
-- 6. Mountain silhouette tile (48x10 repeating)
----------------------------------------------------------------
local function makeMountains()
  local W, H = 48, 10
  local s, img = newSprite(W, H)
  -- Multiple peaks
  local function peakAt(px, ph)
    for dy = 0, ph do
      local span = ph - dy
      for dx = -span, span do
        local x, y = px + dx, H - 1 - dy
        if x >= 0 and x < W and y >= 0 then
          local edge = (dx == -span or dx == span)
          img:drawPixel(x, y, edge and C.mountain2 or C.mountain)
        end
      end
    end
  end
  peakAt(5, 5)
  peakAt(13, 8)
  peakAt(22, 4)
  peakAt(30, 7)
  peakAt(40, 5)
  -- Base ground line
  for x = 0, W-1 do
    img:drawPixel(x, H-1, C.mountain)
    img:drawPixel(x, H-2, C.mountain)
  end
  save(s, "mountains.png")
end

----------------------------------------------------------------
-- 7. Heart (7x6) - on/off variants
----------------------------------------------------------------
local function makeHeart(filename, full)
  local s, img = newSprite(7, 6)
  local fill = full and C.heart or C.heart_e
  local edge = full and C.heart_d or C.heart_e
  blit(img, 0, 0, {
    ".X.X.X.",
    "XXXXXXX",
    "XXXXXXX",
    ".XXXXX.",
    "..XXX..",
    "...X...",
  }, { ["X"] = fill })
  -- Add edge shadow on right & bottom for full heart
  if full then
    blit(img, 0, 0, {
      ".......",
      "......e",
      ".....ee",
      "....ee.",
      "...e...",
      ".......",
    }, { ["e"] = edge })
  end
  save(s, filename)
end

----------------------------------------------------------------
-- 8. Speaker icons (10x6)
----------------------------------------------------------------
local function makeSpeaker(filename, on)
  local s, img = newSprite(10, 6)
  blit(img, 0, 0, {
    "...XX.....",
    "..XSX.....",
    ".XSSX.....",
    "XSSSX.....",
    "XSSSX.....",
    ".XXXX.....",
  }, { ["X"] = C.speaker_y, ["S"] = C.speaker_y })
  if on then
    blit(img, 5, 0, {
      ".w...",
      "w....",
      "..w..",
      "..w..",
      "w....",
      ".w...",
    }, { ["w"] = C.speaker_y })
  else
    blit(img, 5, 1, {
      "X...X",
      ".X.X.",
      "..X..",
      ".X.X.",
      "X...X",
    }, { ["X"] = C.speaker_o })
  end
  save(s, filename)
end

----------------------------------------------------------------
-- 9. Brick (3x3 base — rendered with shading)
----------------------------------------------------------------
local function makeBrick()
  local s, img = newSprite(3, 3)
  blit(img, 0, 0, {
    "HHH",
    "HMS",
    "MSS",
  }, {
    ["H"] = C.brick_b,
    ["M"] = C.brick_a,
    ["S"] = C.brick_c,
  })
  save(s, "brick.png")
end

----------------------------------------------------------------
-- 10. Frame corner & edge tiles (for the outer game border)
----------------------------------------------------------------
local function makeFrameCorner()
  local s, img = newSprite(4, 4)
  blit(img, 0, 0, {
    "AAAA",
    "ABBB",
    "AB..",
    "AB..",
  }, {
    ["A"] = C.border1,
    ["B"] = C.border2,
  })
  save(s, "frame_corner.png")
end
local function makeFrameEdge()
  -- Horizontal edge tile (4x4) — to be tiled along top/bottom
  local s, img = newSprite(4, 4)
  blit(img, 0, 0, {
    "AAAA",
    "BBBB",
    "....",
    "....",
  }, { ["A"] = C.border1, ["B"] = C.border2 })
  save(s, "frame_edge_h.png")

  -- Vertical edge tile
  local s2, img2 = newSprite(4, 4)
  blit(img2, 0, 0, {
    "AB..",
    "AB..",
    "AB..",
    "AB..",
  }, { ["A"] = C.border1, ["B"] = C.border2 })
  save(s2, "frame_edge_v.png")
end

----------------------------------------------------------------
-- 11. Star sprite (small twinkling star, 3x3)
----------------------------------------------------------------
local function makeStar()
  local s, img = newSprite(3, 3)
  blit(img, 0, 0, {
    ".X.",
    "XXX",
    ".X.",
  }, { ["X"] = C.star_w })
  save(s, "star_big.png")

  local s2, img2 = newSprite(1, 1)
  img2:drawPixel(0, 0, C.star_w)
  save(s2, "star_small.png")
end

----------------------------------------------------------------
-- Run all
----------------------------------------------------------------
makeBall()
makePaddle()
makeSaturn()
makeBluePlanet()
makeGalaxy()
makeMountains()
makeHeart("heart_full.png", true)
makeHeart("heart_empty.png", false)
makeSpeaker("speaker_on.png", true)
makeSpeaker("speaker_off.png", false)
makeBrick()
makeFrameCorner()
makeFrameEdge()
makeStar()

print("OK: generated all sprites into " .. OUT)
