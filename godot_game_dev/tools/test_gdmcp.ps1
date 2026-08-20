[CmdletBinding()]
param([switch]$KeepTemp)
$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$Wrapper = Join-Path $Root 'tools\gdmcp.ps1'
function Assert-True([bool]$Condition, [string]$Message) { if (-not $Condition) { throw $Message } }

$PowerShell = Join-Path $PSHOME 'powershell.exe'
$positive = & $PowerShell -NoProfile -ExecutionPolicy Bypass -File $Wrapper -CheckOnly 2>&1 | Out-String
$positiveExit = $LASTEXITCODE
Assert-True ($positiveExit -eq 0) "positive check-only failed: $positive"
Assert-True ($positive -match 'resolved_gdmcp_path=.*\\.gdmcp\\bin\\gdmcp\.exe') 'resolved path was not reported'
Assert-True ($positive -match 'gdmcp_identity=gdmcp ') 'GDMCP identity was not reported'
Assert-True ($positive -match 'GDMCP_LAUNCHER_CHECK_OK') 'check marker missing'
Write-Output 'positive_check_only=PASS'

$temp = Join-Path ([IO.Path]::GetTempPath()) ('gdmcp-launcher-test-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path (Join-Path $temp 'tools') -Force | Out-Null
Copy-Item $Wrapper (Join-Path $temp 'tools\gdmcp.ps1')
New-Item -ItemType File -Path (Join-Path $temp 'project.godot') | Out-Null
try {
  try {
    $ErrorActionPreference = 'Continue'
    $negative = & $PowerShell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $temp 'tools\gdmcp.ps1') -CheckOnly 2>&1 | Out-String
  } finally {
    $ErrorActionPreference = 'Stop'
  }
  $negativeExit = $LASTEXITCODE
  Assert-True ($negativeExit -ne 0) 'missing-binary case unexpectedly succeeded'
  Assert-True ($negative -match 'project-local GDMCP executable not found') 'missing-binary diagnostic missing'
  Assert-True ($negative -match 'PATH fallback is disabled') 'PATH fallback diagnostic missing'
  Write-Output 'negative_missing_binary=PASS'
} finally {
  if (-not $KeepTemp) { Remove-Item $temp -Recurse -Force }
}
Write-Output 'GDMCP_LAUNCHER_TEST_OK'
exit 0
