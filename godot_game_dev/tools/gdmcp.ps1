[CmdletBinding()]
param(
  [switch]$CheckOnly,
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$GdmcpArguments
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$GdmcpPath = Join-Path $ProjectRoot '.gdmcp\bin\gdmcp.exe'
$Timestamp = [DateTime]::UtcNow.ToString('o')

function Write-Audit([string]$Name, [string]$Value) {
  Write-Output ("{0}={1}" -f $Name, $Value)
}
function Fail([string]$Message, [int]$Code = 2) {
  [Console]::Error.WriteLine("gdmcp_launcher_error=$Message")
  exit $Code
}
function Quote-Arg([string]$Value) {
  if ($Value -match '(?i)(token|secret|password|passwd|authorization|credential|api[-_]?key)') {
    return '<redacted>'
  }
  if ($Value -match '[\s"]') { return '"' + ($Value -replace '"', '\"') + '"' }
  return $Value
}
function Read-Log([string]$Path) {
  if (Test-Path -LiteralPath $Path) { return [IO.File]::ReadAllText($Path) }
  return ''
}

Write-Audit 'gdmcp_launcher_timestamp_utc' $Timestamp
Write-Audit 'gdmcp_launcher_identity' 'project-local-wrapper/1'
Write-Audit 'project_root' $ProjectRoot
Write-Audit 'resolved_gdmcp_path' $GdmcpPath
Write-Audit 'path_fallback' 'disabled'
if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot 'project.godot') -PathType Leaf)) {
  Fail "project.godot not found under project root: $ProjectRoot"
}
if (-not (Test-Path -LiteralPath $GdmcpPath -PathType Leaf)) {
  Fail "project-local GDMCP executable not found: $GdmcpPath (PATH fallback is disabled)"
}

$identity = (& $GdmcpPath --version 2>&1 | Out-String).Trim()
$identityExit = $LASTEXITCODE
Write-Audit 'gdmcp_identity' $identity
Write-Audit 'gdmcp_identity_exit_code' $identityExit
if ($identityExit -ne 0) { Fail "GDMCP identity probe failed (exit $identityExit)" $identityExit }
Write-Audit 'godot_identity' 'not-probed-by-launcher'

if ($CheckOnly) {
  if ($GdmcpArguments.Count -gt 0) { Fail '-CheckOnly does not accept GDMCP operation arguments' }
  Write-Audit 'command' ((Quote-Arg $GdmcpPath) + ' --version')
  Write-Audit 'result' 'check-only-ok'
  Write-Output 'GDMCP_LAUNCHER_CHECK_OK'
  exit 0
}
if ($null -eq $GdmcpArguments -or $GdmcpArguments.Count -eq 0) {
  Fail 'No GDMCP arguments supplied; use -CheckOnly or pass an operation such as --json doctor'
}

$redactedArgs = @($GdmcpArguments | ForEach-Object { Quote-Arg $_ })
Write-Audit 'command' ((Quote-Arg $GdmcpPath) + ' ' + ($redactedArgs -join ' '))
Write-Audit 'command_redaction' 'token/secret/password/authorization/credential/api-key values are redacted'
$logBase = Join-Path ([IO.Path]::GetTempPath()) ('gdmcp-launcher-' + [guid]::NewGuid().ToString('N'))
$stdoutLog = "$logBase.stdout.log"
$stderrLog = "$logBase.stderr.log"
try {
  $proc = Start-Process -FilePath $GdmcpPath -ArgumentList $GdmcpArguments -WorkingDirectory $ProjectRoot -RedirectStandardOutput $stdoutLog -RedirectStandardError $stderrLog -PassThru
  $proc.WaitForExit()
  $proc.Refresh()
  $exitCode = [int]$proc.ExitCode
  $stdout = Read-Log $stdoutLog
  $stderr = Read-Log $stderrLog
  Write-Output 'stdout_begin'
  if ($stdout.Length -gt 0) { Write-Output $stdout.TrimEnd() }
  Write-Output 'stdout_end'
  Write-Output 'stderr_begin'
  if ($stderr.Length -gt 0) { [Console]::Error.WriteLine($stderr.TrimEnd()) }
  Write-Output 'stderr_end'
  Write-Audit 'stdout_log' $stdoutLog
  Write-Audit 'stderr_log' $stderrLog
  Write-Audit 'exit_code' $exitCode
  if ($exitCode -ne 0) { exit $exitCode }
  exit 0
} catch {
  Fail ("GDMCP launch failed: " + $_.Exception.Message)
} finally {
  # Logs remain in the temp directory so the action evidence is recoverable.
}
