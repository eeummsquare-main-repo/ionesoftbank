# ASCII-only PowerShell HTTP server with SVG placeholders. Labels loaded from JSON (UTF-8).
Add-Type -AssemblyName System.Web

$root      = 'c:\Users\USER\_'
$prefix    = 'http://localhost:9080/'
$labelFile = 'c:\Users\USER\_\_local_preview_labels.json'

# Load labels as UTF-8 to avoid system code page corruption
$labelData = $null
try {
    $json = [System.IO.File]::ReadAllText($labelFile, [System.Text.Encoding]::UTF8)
    $labelData = $json | ConvertFrom-Json
} catch {
    Write-Host ("WARN: failed to read labels: " + $_.Exception.Message)
}

# Build a flat lookup PSObject
$exactMap = @{}
if ($labelData) {
    foreach ($section in @('exact','extra')) {
        $obj = $labelData.$section
        if ($obj) {
            foreach ($p in $obj.PSObject.Properties) { $exactMap[$p.Name] = $p.Value }
        }
    }
}
$iconLabels = @()
if ($labelData -and $labelData.iconLabels03) { $iconLabels = @($labelData.iconLabels03) }

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add($prefix)
try {
    $listener.Start()
} catch {
    Write-Host ("FAILED to start listener: " + $_.Exception.Message)
    exit 1
}
Write-Host ("Listening at " + $prefix + " (root: " + $root + ")")
Write-Host  "Open: http://localhost:9080/product/oneai_preview.html"

$mime = @{
    '.html' = 'text/html; charset=utf-8'; '.htm' = 'text/html; charset=utf-8'; '.asp' = 'text/html; charset=utf-8'
    '.css'  = 'text/css; charset=utf-8'; '.js' = 'application/javascript; charset=utf-8'; '.json' = 'application/json; charset=utf-8'
    '.png'  = 'image/png'; '.jpg' = 'image/jpeg'; '.jpeg' = 'image/jpeg'; '.gif' = 'image/gif'; '.svg' = 'image/svg+xml'
    '.ico'  = 'image/x-icon'; '.webp' = 'image/webp'
    '.woff' = 'font/woff'; '.woff2' = 'font/woff2'; '.ttf' = 'font/ttf'; '.eot' = 'application/vnd.ms-fontobject'; '.otf' = 'font/otf'
    '.mp4'  = 'video/mp4'; '.map' = 'application/json'
}

function New-PlaceholderSvg {
    param([string]$basename)

    $info = $null
    if ($exactMap.ContainsKey($basename)) { $info = $exactMap[$basename] }

    $title = ''
    $sub = ''
    $w = 600
    $h = 400
    $icon = ''
    $isIconStyle = $false

    if ($info) {
        $title = [string]$info.title
        $sub   = [string]$info.sub
        if ($info.w) { $w = [int]$info.w }
        if ($info.h) { $h = [int]$info.h }
        if ($info.PSObject.Properties.Name -contains 'icon' -and $info.icon) {
            $icon = [string]$info.icon
            $isIconStyle = $true
        }
    } elseif ($basename -match '^oneai_03_icon(\d+)$') {
        $n = [int]$matches[1]
        $idx = $n - 1
        if ($idx -ge 0 -and $idx -lt $iconLabels.Length) { $icon = [string]$iconLabels[$idx] } else { $icon = '*' }
        $title = "icon " + $n.ToString('00')
        $w = 100; $h = 100
        $isIconStyle = $true
    } else {
        $title = $basename
        $sub = 'ONE AI placeholder'
    }

    $titleEsc = [System.Web.HttpUtility]::HtmlEncode($title)
    $subEsc   = [System.Web.HttpUtility]::HtmlEncode($sub)
    $iconEsc  = [System.Web.HttpUtility]::HtmlEncode($icon)

    if ($isIconStyle) {
        $cx = [int]($w/2); $cy = [int]($h/2)
        $r = [int]([Math]::Min($w,$h)/2 - 4)
        $fontSize = [int]($r*0.85)
        $textY = [int]($cy + $r*0.28)
        $svg = "<svg xmlns='http://www.w3.org/2000/svg' width='$w' height='$h' viewBox='0 0 $w $h'>" +
               "<defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'>" +
               "<stop offset='0' stop-color='#7C3AED'/><stop offset='1' stop-color='#2563EB'/>" +
               "</linearGradient></defs>" +
               "<circle cx='$cx' cy='$cy' r='$r' fill='url(#g)'/>" +
               "<text x='$cx' y='$textY' text-anchor='middle' fill='white' font-size='$fontSize' font-family='Segoe UI, sans-serif' font-weight='700'>$iconEsc</text>" +
               "</svg>"
    } else {
        $dots = ''
        for ($i = 0; $i -lt 18; $i++) {
            $dx = (($i * 37) % $w)
            $dy = (($i * 53) % $h)
            $dr = (($i % 4) + 2)
            $dots += "<circle cx='$dx' cy='$dy' r='$dr' fill='white' opacity='0.12'/>"
        }
        $titleY = [int]($h/2 - 4)
        $subY   = [int]($h/2 + 34)
        $tagY   = $h - 24
        $tagX   = $w - 18
        $titleSize = [int]([Math]::Min(40, [Math]::Max(22, $w/22)))
        $subSize   = [int]([Math]::Min(22, [Math]::Max(14, $w/36)))
        $svg = "<svg xmlns='http://www.w3.org/2000/svg' width='$w' height='$h' viewBox='0 0 $w $h'>" +
               "<defs>" +
               "<linearGradient id='bg' x1='0' y1='0' x2='1' y2='1'>" +
               "<stop offset='0' stop-color='#6D28D9'/><stop offset='0.5' stop-color='#4F46E5'/><stop offset='1' stop-color='#06B6D4'/>" +
               "</linearGradient>" +
               "<linearGradient id='overlay' x1='0' y1='1' x2='0' y2='0'>" +
               "<stop offset='0' stop-color='#000' stop-opacity='0.25'/><stop offset='1' stop-color='#000' stop-opacity='0'/>" +
               "</linearGradient>" +
               "</defs>" +
               "<rect width='$w' height='$h' fill='url(#bg)'/>" +
               $dots +
               "<rect width='$w' height='$h' fill='url(#overlay)'/>" +
               "<text x='40' y='56' fill='white' font-size='18' font-family='Segoe UI, sans-serif' font-weight='700' opacity='0.85'>ONE AI</text>" +
               "<text x='$([int]($w/2))' y='$titleY' text-anchor='middle' fill='white' font-size='$titleSize' font-family='Segoe UI, sans-serif' font-weight='800'>$titleEsc</text>" +
               "<text x='$([int]($w/2))' y='$subY' text-anchor='middle' fill='white' font-size='$subSize' font-family='Segoe UI, sans-serif' font-weight='500' opacity='0.92'>$subEsc</text>" +
               "<text x='$tagX' y='$tagY' text-anchor='end' fill='white' font-size='11' font-family='Segoe UI, sans-serif' opacity='0.7'>placeholder</text>" +
               "</svg>"
    }
    return $svg
}

while ($listener.IsListening) {
    try { $ctx = $listener.GetContext() } catch { break }
    $req = $ctx.Request
    $res = $ctx.Response
    try {
        $absPath = $req.Url.AbsolutePath
        $rel = [System.Web.HttpUtility]::UrlDecode($absPath).TrimStart('/').Replace('/', '\')
        if ([string]::IsNullOrWhiteSpace($rel)) { $rel = 'index.html' }
        $path = Join-Path $root $rel

        $exists = (Test-Path $path) -and -not (Get-Item $path -ErrorAction SilentlyContinue).PSIsContainer
        $ext = [System.IO.Path]::GetExtension($path).ToLower()
        $isImage = $ext -in '.png','.jpg','.jpeg','.gif','.webp','.svg'

        if ($exists) {
            $ct = $mime[$ext]; if (-not $ct) { $ct = 'application/octet-stream' }
            $bytes = [System.IO.File]::ReadAllBytes($path)
            $res.ContentType = $ct
            $res.ContentLength64 = $bytes.Length
            $res.StatusCode = 200
            $res.OutputStream.Write($bytes, 0, $bytes.Length)
            Write-Host ("200 " + $absPath)
        } elseif ($isImage) {
            $base = [System.IO.Path]::GetFileNameWithoutExtension($path)
            $svg = New-PlaceholderSvg -basename $base
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($svg)
            $res.ContentType = 'image/svg+xml; charset=utf-8'
            $res.ContentLength64 = $bytes.Length
            $res.StatusCode = 200
            $res.OutputStream.Write($bytes, 0, $bytes.Length)
            Write-Host ("200(svg) " + $absPath)
        } else {
            $res.StatusCode = 404
            $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: " + $rel)
            $res.OutputStream.Write($msg, 0, $msg.Length)
            Write-Host ("404 " + $absPath)
        }
    } catch {
        try { $res.StatusCode = 500 } catch {}
        Write-Host ("500 " + $req.Url.AbsolutePath + ": " + $_.Exception.Message)
    } finally {
        try { $res.Close() } catch {}
    }
}
