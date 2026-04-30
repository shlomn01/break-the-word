-- Generate a Hebrew pixel-art bitmap font sheet.
-- Each glyph is 5x7 px, white-on-transparent. Output: hebfont.png + hebfont_index.json
-- The JS loads the PNG and reads the pixel data of each cell to know which positions are lit.

local OUT = "../../assets/sprites/"
local META = "../../assets/sprites/hebfont_index.json"

local W = 5    -- glyph width
local H = 7    -- glyph height

-- Each glyph is 7 rows x 5 cols using "X" for lit, "." or " " for empty.
-- Designs are pragmatic — recognizable Hebrew letters at small size.
local glyphs = {
  -- Hebrew alphabet
  ["א"] = { "X...X",
            ".X.X.",
            ".XXX.",
            "X.X..",
            "X.X..",
            "X..X.",
            "X..XX" },

  ["ב"] = { "XXXXX",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X",
            "XXXXX" },

  ["ג"] = { "..XX.",
            ".X.X.",
            "...X.",
            "...X.",
            "...X.",
            "...X.",
            ".XX..", },

  ["ד"] = { "XXXXX",
            "X...X",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X" },

  ["ה"] = { "XXXXX",
            "....X",
            "....X",
            "....X",
            "X....",
            "X....",
            "X...." },

  ["ו"] = { "...XX",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X" },

  ["ז"] = { "XXXX.",
            "..X..",
            "..X..",
            "..X..",
            "..X..",
            "..X..",
            "..X.." },

  ["ח"] = { "XXXXX",
            "X...X",
            "X...X",
            "X...X",
            "X...X",
            "X...X",
            "X...X" },

  ["ט"] = { "X...X",
            "X.X.X",
            "X.X.X",
            "X.X.X",
            ".XX.X",
            "....X",
            "XXXXX" },

  ["י"] = { "..XXX",
            "...X.",
            "...X.",
            ".....",
            ".....",
            ".....",
            "....." },

  ["כ"] = { "XXXXX",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X",
            "XXXX." },

  ["ך"] = { "XXXXX",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X" },

  ["ל"] = { ".XX..",
            "X..X.",
            "...X.",
            "...X.",
            "...X.",
            "...X.",
            "...X." },

  ["מ"] = { "XXXXX",
            "X...X",
            "X...X",
            "X...X",
            "X...X",
            "X...X",
            "X.XXX" },

  ["ם"] = { "XXXXX",
            "X...X",
            "X...X",
            "X...X",
            "X...X",
            "X...X",
            "XXXXX" },

  ["נ"] = { "XXXXX",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X",
            "XXXXX" },

  ["ן"] = { "....X",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X" },

  ["ס"] = { "XXXXX",
            "X...X",
            "X...X",
            "X...X",
            "X...X",
            "X...X",
            "XXXXX" },

  ["ע"] = { "X...X",
            "X.X.X",
            ".X.X.",
            "..X.X",
            "....X",
            "....X",
            "XXXXX" },

  ["פ"] = { "XXXXX",
            "....X",
            ".XX.X",
            "X..XX",
            "....X",
            "....X",
            "XXXXX" },

  ["ף"] = { "XXXXX",
            "....X",
            ".XX.X",
            "X..XX",
            "....X",
            "....X",
            "....X" },

  ["צ"] = { "X...X",
            "X.X.X",
            "X.X..",
            ".X...",
            ".X...",
            ".X...",
            "XXXXX" },

  ["ץ"] = { "X...X",
            "X.X.X",
            "X.X..",
            ".X...",
            "....X",
            "....X",
            "....X" },

  ["ק"] = { "XXXXX",
            "X...X",
            "....X",
            "....X",
            ".X..X",
            ".X...",
            ".X..." },

  ["ר"] = { "XXXXX",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X",
            "....X" },

  ["ש"] = { "X.X.X",
            "X.X.X",
            "X.X.X",
            "X.X.X",
            "X.X.X",
            "X.XXX",
            "XXXXX" },

  ["ת"] = { "XXXXX",
            "X...X",
            "....X",
            "....X",
            "....X",
            "....X",
            "X...X" },

  -- Digits
  ["0"] = { ".XXX.",
            "X...X",
            "X..XX",
            "X.X.X",
            "XX..X",
            "X...X",
            ".XXX." },

  ["1"] = { "..X..",
            ".XX..",
            "..X..",
            "..X..",
            "..X..",
            "..X..",
            ".XXX." },

  ["2"] = { ".XXX.",
            "X...X",
            "....X",
            "...X.",
            "..X..",
            ".X...",
            "XXXXX" },

  ["3"] = { ".XXX.",
            "X...X",
            "....X",
            "..XX.",
            "....X",
            "X...X",
            ".XXX." },

  ["4"] = { "...X.",
            "..XX.",
            ".X.X.",
            "X..X.",
            "XXXXX",
            "...X.",
            "...X." },

  ["5"] = { "XXXXX",
            "X....",
            "XXXX.",
            "....X",
            "....X",
            "X...X",
            ".XXX." },

  ["6"] = { ".XXX.",
            "X....",
            "X....",
            "XXXX.",
            "X...X",
            "X...X",
            ".XXX." },

  ["7"] = { "XXXXX",
            "....X",
            "...X.",
            "...X.",
            "..X..",
            "..X..",
            ".X..." },

  ["8"] = { ".XXX.",
            "X...X",
            "X...X",
            ".XXX.",
            "X...X",
            "X...X",
            ".XXX." },

  ["9"] = { ".XXX.",
            "X...X",
            "X...X",
            ".XXXX",
            "....X",
            "....X",
            ".XXX." },

  -- Punctuation
  [" "] = { ".....",".....",".....",".....",".....",".....","....." },
  ["?"] = { ".XXX.","X...X","....X","..XX.","..X..",".....","..X.." },
  ["!"] = { "..X..","..X..","..X..","..X..","..X..",".....","..X.." },
  ["."] = { ".....",".....",".....",".....",".....",".....","..X.." },
  [","] = { ".....",".....",".....",".....","..X..","..X..",".X..." },
  [":"] = { ".....","..X..",".....",".....","..X..",".....","....." },
  ["/"] = { "....X","....X","...X.","..X..",".X...","X....","X...." },
  ["-"] = { ".....",".....",".....","XXXXX",".....",".....","....." },
  ["'"] = { "..X..","..X..",".....",".....",".....",".....","....." },
}

-- Order glyphs alphabetically (Hebrew first, then digits, then punctuation)
local ORDER = {
  "א","ב","ג","ד","ה","ו","ז","ח","ט","י",
  "כ","ך","ל","מ","ם","נ","ן","ס","ע","פ","ף","צ","ץ","ק","ר","ש","ת",
  "0","1","2","3","4","5","6","7","8","9",
  " ","?","!",".",",",":","/","-","'"
}

local N = #ORDER
local sheetW = N * W
local sheetH = H

local sprite = Sprite(sheetW, sheetH, ColorMode.RGB)
local img = sprite.cels[1].image
local white = app.pixelColor.rgba(255, 255, 255, 255)

local mapping = {}
for i, ch in ipairs(ORDER) do
  local rows = glyphs[ch]
  if rows then
    for y = 0, H - 1 do
      local row = rows[y + 1] or ("." .. string.rep(".", W - 1))
      for x = 0, W - 1 do
        local c = row:sub(x + 1, x + 1)
        if c == "X" or c == "1" then
          img:drawPixel((i - 1) * W + x, y, white)
        end
      end
    end
    mapping[ch] = i - 1
  end
end

sprite:saveCopyAs(OUT .. "hebfont.png")

-- Write JSON mapping
local f = io.open(META, "w")
f:write("{\n")
f:write('  "width": ' .. W .. ',\n')
f:write('  "height": ' .. H .. ',\n')
f:write('  "spacing": 1,\n')
f:write('  "glyphs": {\n')
local entries = {}
for ch, idx in pairs(mapping) do
  -- Escape quote and backslash for JSON. Other chars are UTF-8 and pass through.
  local k = ch
  if k == '"' then k = '\\"' end
  if k == '\\' then k = '\\\\' end
  table.insert(entries, '    "' .. k .. '": ' .. idx)
end
f:write(table.concat(entries, ",\n"))
f:write("\n  }\n")
f:write("}\n")
f:close()

print("OK: hebfont.png " .. sheetW .. "x" .. sheetH .. ", " .. N .. " glyphs")
