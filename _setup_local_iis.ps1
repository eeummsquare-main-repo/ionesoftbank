# Local IIS setup for c:\Users\USER\_ (Classic ASP)
# Run as Administrator: right-click -> "Run with PowerShell" (elevated),
# or from an elevated PowerShell:  powershell -ExecutionPolicy Bypass -File .\_setup_local_iis.ps1

$ErrorActionPreference = 'Stop'

$siteName = 'DuzonLocal'
$sitePath = 'c:\Users\USER\_'
$port     = 8081
$appPool  = 'DuzonLocalPool'

Write-Host "== Duzon local IIS setup ==" -ForegroundColor Cyan

# 1) Ensure IIS features (ASP + ISAPI + Default Doc + Static Content)
$features = @(
    'IIS-WebServerRole',
    'IIS-WebServer',
    'IIS-CommonHttpFeatures',
    'IIS-StaticContent',
    'IIS-DefaultDocument',
    'IIS-DirectoryBrowsing',
    'IIS-HttpErrors',
    'IIS-ApplicationDevelopment',
    'IIS-ASP',
    'IIS-ISAPIExtensions',
    'IIS-ISAPIFilter',
    'IIS-RequestFiltering'
)
foreach ($f in $features) {
    $state = (Get-WindowsOptionalFeature -Online -FeatureName $f).State
    if ($state -ne 'Enabled') {
        Write-Host "Enabling $f ..." -ForegroundColor Yellow
        Enable-WindowsOptionalFeature -Online -FeatureName $f -All -NoRestart | Out-Null
    } else {
        Write-Host "OK    $f"
    }
}

Import-Module WebAdministration

# 2) App pool (Classic pipeline, No Managed Code -> ASP Classic 안정)
if (-not (Test-Path "IIS:\AppPools\$appPool")) {
    New-WebAppPool -Name $appPool | Out-Null
}
Set-ItemProperty "IIS:\AppPools\$appPool" -Name managedRuntimeVersion -Value ''
Set-ItemProperty "IIS:\AppPools\$appPool" -Name managedPipelineMode -Value 'Classic'
Set-ItemProperty "IIS:\AppPools\$appPool" -Name enable32BitAppOnWin64 -Value $true

# 3) Site
if (Test-Path "IIS:\Sites\$siteName") {
    Write-Host "Site $siteName already exists — updating binding/path"
    Set-ItemProperty "IIS:\Sites\$siteName" -Name physicalPath -Value $sitePath
    Set-ItemProperty "IIS:\Sites\$siteName" -Name applicationPool -Value $appPool
} else {
    New-Website -Name $siteName -Port $port -PhysicalPath $sitePath -ApplicationPool $appPool | Out-Null
}

# 4) ASP settings: enableParentPaths (for #include virtual), scriptErrorSentToBrowser, codepage 65001
$location = "$siteName"
& "$env:windir\system32\inetsrv\appcmd.exe" set config $location -section:asp /enableParentPaths:"True" /commit:apphost | Out-Null
& "$env:windir\system32\inetsrv\appcmd.exe" set config $location -section:asp /scriptErrorSentToBrowser:"True" /commit:apphost | Out-Null
& "$env:windir\system32\inetsrv\appcmd.exe" set config $location -section:asp /codePage:65001 /commit:apphost | Out-Null
& "$env:windir\system32\inetsrv\appcmd.exe" set config $location -section:asp /bufferingOn:"True" /commit:apphost | Out-Null
& "$env:windir\system32\inetsrv\appcmd.exe" set config $location -section:asp /session.timeout:"00:30:00" /commit:apphost | Out-Null

# 5) Default document -> index.asp first
& "$env:windir\system32\inetsrv\appcmd.exe" set config $location -section:defaultDocument /+"files.[value='index.asp']" /commit:apphost 2>$null | Out-Null

# 6) Grant IIS_IUSRS read on the folder (safe)
$acl = Get-Acl $sitePath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule('IIS_IUSRS','ReadAndExecute','ContainerInherit,ObjectInherit','None','Allow')
$acl.SetAccessRule($rule)
Set-Acl -Path $sitePath -AclObject $acl

# 7) Start
Start-WebAppPool -Name $appPool -ErrorAction SilentlyContinue
Start-Website  -Name $siteName -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Done. Open http://localhost:$port/index.asp" -ForegroundColor Green
Write-Host "  Purchase page: http://localhost:$port/purchase/inquiry.asp"
Write-Host "  Backoffice   : http://localhost:$port/backoffice/"
Write-Host ""
Write-Host "Note: DB 연결(_lib/common.asp)이 원격 DB 접근을 시도하면 로컬에서는 실패할 수 있음."
Write-Host "     퍼블리싱된 마크업/링크 이동/폼 필드 확인 용도로 사용."
