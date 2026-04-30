-- Quickly visualize the generated font: load hebfont.png, draw a sample word
-- with a dark background, save as preview_font.png in the script folder.
local font = Image{ fromFile = "../../assets/sprites/hebfont.png" }

-- Glyph indexes (must match hebfont.lua ORDER table)
local idx = {
  ["א"]=0,["ב"]=1,["ג"]=2,["ד"]=3,["ה"]=4,["ו"]=5,["ז"]=6,["ח"]=7,["ט"]=8,["י"]=9,
  ["כ"]=10,["ך"]=11,["ל"]=12,["מ"]=13,["ם"]=14,["נ"]=15,["ן"]=16,["ס"]=17,["ע"]=18,
  ["פ"]=19,["ף"]=20,["צ"]=21,["ץ"]=22,["ק"]=23,["ר"]=24,["ש"]=25,["ת"]=26,
  ["0"]=27,["1"]=28,["2"]=29,["3"]=30,["4"]=31,["5"]=32,["6"]=33,["7"]=34,["8"]=35,["9"]=36,
}

-- Draw all letters of the alphabet on a dark background
local W, H = 5, 7
local cols = 14
local letters = { "א","ב","ג","ד","ה","ו","ז","ח","ט","י","כ","ך","ל","מ",
                  "ם","נ","ן","ס","ע","פ","ף","צ","ץ","ק","ר","ש","ת" }
local rows = math.ceil(#letters / cols)
local pad = 1
local cellW = W + pad * 2
local cellH = H + pad * 2
local sheetW = cols * cellW + 4
local sheetH = rows * cellH + 4

local s = Sprite(sheetW, sheetH, ColorMode.RGB)
local img = s.cels[1].image

-- fill bg dark
for y = 0, sheetH - 1 do
  for x = 0, sheetW - 1 do
    img:drawPixel(x, y, app.pixelColor.rgba(20, 12, 50, 255))
  end
end

-- For each letter, copy the glyph from font with bright orange color
local orange = app.pixelColor.rgba(255, 138, 61, 255)
for i, ch in ipairs(letters) do
  local gi = idx[ch]
  if gi then
    local row = math.floor((i - 1) / cols)
    local col = (i - 1) % cols
    local ox = 2 + col * cellW + pad
    local oy = 2 + row * cellH + pad
    for y = 0, H - 1 do
      for x = 0, W - 1 do
        local px = font:getPixel(gi * W + x, y)
        if app.pixelColor.rgbaA(px) > 100 then
          img:drawPixel(ox + x, oy + y, orange)
        end
      end
    end
  end
end

s:saveCopyAs("preview_font.png")
print("OK: preview_font.png written")
