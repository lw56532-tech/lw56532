#requires -Version 3.0
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$paths = @(
    'quiz.html',
    'robotics\robotics\index.html',
    'computer-repair\index.html',
    'resistor-capacitor.html',
    'color-code-game.html'
)
$style = @'
<style id="school-home-link-style">
/* 共同入口：市立泰山高中學生互動練習平台 */
#school-home-link {
  position: fixed; right: 18px; bottom: 18px; z-index: 2147483000;
  display: inline-flex; align-items: center; justify-content: center; gap: 8px;
  padding: 11px 17px; min-height: 46px; border-radius: 999px;
  border: 1px solid rgba(255,255,255,.35);
  background: #1d4f91; color: #fff !important;
  font: 700 15px/1.4 "Microsoft JhengHei", "Noto Sans TC", system-ui, sans-serif;
  text-decoration: none !important;
  box-shadow: 0 6px 20px rgba(10,30,55,.27);
  transition: background .15s, transform .15s;
}
#school-home-link:hover { background: #153d72; transform: translateY(-2px); }
#school-home-link:focus-visible { outline: 3px solid #f59e0b; outline-offset: 3px; }
@media (max-width: 600px) {
  #school-home-link { right: 12px; bottom: calc(12px + env(safe-area-inset-bottom, 0px)); font-size: 13px; padding: 9px 13px; min-height: 42px; }
}
@media print { #school-home-link { display: none !important; } }
</style>
'@
$button = @'
<a id="school-home-link" href="https://lw56532-tech.github.io/lw56532/" aria-label="返回市立泰山高中學生互動練習平台總首頁" title="返回市立泰山高中學生互動練習平台">🏠 返回學校總首頁</a>
'@
# Verify all expected files before modifying anything.
$missing = @($paths | Where-Object { -not (Test-Path -LiteralPath (Join-Path $root $_) -PathType Leaf) })
if ($missing.Count -gt 0) {
    Write-Host '[ERROR] Please put BOTH the .bat and .ps1 files in the lw56532 repository ROOT.' -ForegroundColor Red
    Write-Host 'Missing files:' -ForegroundColor Red
    $missing | ForEach-Object { Write-Host "  $_" }
    exit 1
}
$utf8 = New-Object System.Text.UTF8Encoding($false)
$changed = 0
$skipped = 0
foreach ($rel in $paths) {
    $path = Join-Path $root $rel
    $html = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    if ($html.Contains('id="school-home-link"')) {
        Write-Host "[SKIP] $rel (already installed)" -ForegroundColor Yellow
        $skipped++
        continue
    }
    if (-not $html.Contains('</head>') -or -not $html.Contains('</body>')) {
        Write-Host "[ERROR] Unexpected HTML structure: $rel" -ForegroundColor Red
        exit 2
    }
    $patched = $html.Replace('</head>', $style + "`r`n</head>")
    $patched = $patched.Replace('</body>', $button + "`r`n</body>")
    [System.IO.File]::WriteAllText($path, $patched, $utf8)
    Write-Host "[OK] $rel" -ForegroundColor Green
    $changed++
}
Write-Host ""
Write-Host "Complete: $changed modified; $skipped already installed. Return to GitHub Desktop." -ForegroundColor Cyan
Write-Host 'Commit the changed HTML files, then click Push origin.' -ForegroundColor Cyan
