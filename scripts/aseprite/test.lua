-- Aseprite Lua sanity check: create a 16x16 sprite, draw a tiny pattern, export to PNG.
local sprite = Sprite(16, 16, ColorMode.RGB)
sprite.filename = "test.aseprite"

local cel = sprite.cels[1]
local img = cel.image

-- Draw a simple checkerboard
for y = 0, 15 do
  for x = 0, 15 do
    local on = ((x + y) % 2 == 0)
    local c = on
      and app.pixelColor.rgba(255, 138, 61, 255)   -- orange
      or  app.pixelColor.rgba(26, 15, 58, 255)     -- navy
    img:drawPixel(x, y, c)
  end
end

-- Export PNG
sprite:saveCopyAs("test_output.png")
print("OK: wrote test_output.png at " .. tostring(sprite.width) .. "x" .. tostring(sprite.height))
