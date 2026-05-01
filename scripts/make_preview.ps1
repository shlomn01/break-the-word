Add-Type -AssemblyName System.Drawing

$W = 1200
$H = 630
$out = "C:\Users\shlom\projects\שבור את המילה\assets\preview.png"

$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Background: vertical gradient like the game
$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $rect,
    [System.Drawing.Color]::FromArgb(255, 26, 15, 58),
    [System.Drawing.Color]::FromArgb(255, 90, 30, 50),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($bgBrush, $rect)

# Radial-ish glow at top center using semi-transparent ellipse
$glowBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush(@(
    (New-Object System.Drawing.Point(0, -100)),
    (New-Object System.Drawing.Point($W, -100)),
    (New-Object System.Drawing.Point($W, 350)),
    (New-Object System.Drawing.Point(0, 350))
))

# Brick wall (gold bricks) - 12 cols x 4 rows at top
$brickW = 78
$brickH = 38
$cols = 12
$rows = 4
$wallW = $cols * $brickW
$wallX = ($W - $wallW) / 2
$wallY = 60
$letters = @('ש','ב','ו','ר','א','ת','ה','מ','י','ל','ה','!')
$letFont = New-Object System.Drawing.Font("Arial", 22, [System.Drawing.FontStyle]::Bold)
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center
$sf.LineAlignment = [System.Drawing.StringAlignment]::Center

for ($r = 0; $r -lt $rows; $r++) {
    for ($c = 0; $c -lt $cols; $c++) {
        $bx = $wallX + $c * $brickW
        $by = $wallY + $r * $brickH
        $brickRect = New-Object System.Drawing.RectangleF($bx, $by, ($brickW - 2), ($brickH - 2))
        $top = [System.Drawing.Color]::FromArgb(255, 255, 217, 102)
        $bot = [System.Drawing.Color]::FromArgb(255, 201, 138, 30)
        $bb = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            $brickRect, $top, $bot,
            [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
        $g.FillRectangle($bb, $brickRect)
        # highlight
        $hl = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(140, 255, 245, 184))
        $g.FillRectangle($hl, $bx, $by, ($brickW - 2), 4)
        $hl.Dispose()
        # outline
        $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 106, 74, 10), 1.5)
        $g.DrawRectangle($pen, $bx, $by, ($brickW - 2), ($brickH - 2))
        $pen.Dispose()
        $bb.Dispose()

        # letter on row 1 only
        if ($r -eq 1) {
            $letter = $letters[$c]
            $lb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 58, 26, 4))
            $g.DrawString($letter, $letFont, $lb, (New-Object System.Drawing.RectangleF($bx, $by, ($brickW - 2), ($brickH - 2))), $sf)
            $lb.Dispose()
        }
    }
}

# Title "שבור את המילה" centered, big
$titleFont = $null
$families = @("Arial Hebrew", "Heebo", "Arial Black", "Arial", "Segoe UI")
foreach ($fam in $families) {
    try {
        $titleFont = New-Object System.Drawing.Font($fam, 92, [System.Drawing.FontStyle]::Bold)
        break
    } catch {}
}
$title = "שבור את המילה"
$titleY = 290

# Shadow / outline (multi-pass for glow)
foreach ($d in 6,5,4,3) {
    $sb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(60, 255, 138, 61))
    $g.DrawString($title, $titleFont, $sb, (New-Object System.Drawing.RectangleF(0, ($titleY + $d), $W, 130)), $sf)
    $g.DrawString($title, $titleFont, $sb, (New-Object System.Drawing.RectangleF($d, $titleY, $W, 130)), $sf)
    $sb.Dispose()
}
# dark drop shadow
$shadow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 106, 26, 26))
$g.DrawString($title, $titleFont, $shadow, (New-Object System.Drawing.RectangleF(6, ($titleY + 6), $W, 130)), $sf)
$shadow.Dispose()
# main fill
$titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 138, 61))
$g.DrawString($title, $titleFont, $titleBrush, (New-Object System.Drawing.RectangleF(0, $titleY, $W, 130)), $sf)
$titleBrush.Dispose()

# Subtitle
$subFont = $null
foreach ($fam in $families) {
    try {
        $subFont = New-Object System.Drawing.Font($fam, 28, [System.Drawing.FontStyle]::Bold)
        break
    } catch {}
}
$sub = "משחק קריאה ארקייד בעברית"
$subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 217, 102))
$g.DrawString($sub, $subFont, $subBrush, (New-Object System.Drawing.RectangleF(0, 410, $W, 50)), $sf)
$subBrush.Dispose()

# Paddle (red with white tips) at bottom center
$paddleY = 530
$paddleW = 180
$paddleH = 22
$paddleX = ($W - $paddleW) / 2
$pBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 60, 70))
$g.FillRectangle($pBrush, $paddleX, $paddleY, $paddleW, $paddleH)
$pBrush.Dispose()
$tip = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 250, 250, 250))
$g.FillRectangle($tip, $paddleX, $paddleY, 16, $paddleH)
$g.FillRectangle($tip, ($paddleX + $paddleW - 16), $paddleY, 16, $paddleH)
$tip.Dispose()

# Glowing ball above paddle
$ballX = $W / 2 - 12
$ballY = $paddleY - 30
# glow
foreach ($r in 30,22,14) {
    $alpha = [int](40 + (30 - $r) * 4)
    $gb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($alpha, 255, 217, 102))
    $g.FillEllipse($gb, ($ballX + 12 - $r), ($ballY + 12 - $r), ($r * 2), ($r * 2))
    $gb.Dispose()
}
$ball = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 217, 102))
$g.FillEllipse($ball, $ballX, $ballY, 24, 24)
$ball.Dispose()
$bhl = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 245, 184))
$g.FillEllipse($bhl, ($ballX + 6), ($ballY + 6), 8, 8)
$bhl.Dispose()

# Bottom border accent
$accent = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 138, 61), 4)
$g.DrawRectangle($accent, 2, 2, ($W - 4), ($H - 4))
$accent.Dispose()

# Save
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
Write-Host "Saved: $out"
