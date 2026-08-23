[CmdletBinding()]
param(
  [switch]$CheckOnly,
  [switch]$ShowHost,
  [string]$PythonPath,
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
function Format-RedactedArgs([string[]]$Arguments) {
  $sensitive = @('--token','--secret','--password','--passwd','--authorization','--credential','--api-key','--apikey')
  $result = @()
  $redactNext = $false
  foreach ($argument in $Arguments) {
    $lower = $argument.ToLowerInvariant()
    if ($redactNext) {
      $result += '<redacted>'
      $redactNext = $false
    } elseif ($sensitive -contains $lower) {
      $result += (Quote-Arg $argument)
      $redactNext = $true
    } elseif (($sensitive | Where-Object { $lower.StartsWith($_ + '=') }).Count -gt 0) {
      $result += ((Quote-Arg ($argument.Split('=',2)[0])) + '=<redacted>')
    } else {
      $result += (Quote-Arg $argument)
    }
  }
  return $result
}
function Resolve-Python([string]$Requested) {
  $candidate = $Requested
  if ([string]::IsNullOrWhiteSpace($candidate)) {
    $command = @(Get-Command python.exe -CommandType Application -ErrorAction Stop | Where-Object { Test-Path -LiteralPath $_.Source } | Select-Object -First 1)
    if ($command.Count -ne 1) { Fail 'No usable python.exe application was found' }
    $candidate = $command[0].Source
  }
  $resolved = (Resolve-Path -LiteralPath $candidate -ErrorAction Stop).Path
  $probe = (& $resolved -c "import sys; print(sys.executable); print(sys.version.split()[0])" 2>&1 | Out-String).Trim().Split("`n")
  if ($LASTEXITCODE -ne 0 -or $probe.Count -lt 2) { Fail "Python resolver failed: $resolved" }
  return $resolved
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

$BackgroundLauncher = Join-Path $PSScriptRoot 'background_process.py'
if (-not (Test-Path -LiteralPath $BackgroundLauncher -PathType Leaf)) {
  Fail "background launcher not found: $BackgroundLauncher"
}
$Python = Resolve-Python $PythonPath
$PythonVersion = (& $Python -c "import sys; print(sys.version.split()[0])" 2>&1 | Out-String).Trim()
Write-Audit 'python_path' $Python
Write-Audit 'python_version' $PythonVersion
$redactedArgs = @(Format-RedactedArgs $GdmcpArguments)
Write-Audit 'command' ((Quote-Arg $GdmcpPath) + ' ' + ($redactedArgs -join ' '))
Write-Audit 'command_redaction' 'token/secret/password/authorization/credential/api-key flags and values are redacted'
$logDirectory = Join-Path ([IO.Path]::GetTempPath()) 'new-game-background'
$launcherArgs = @($BackgroundLauncher,'run','--profile','gdmcp','--cwd',$ProjectRoot,'--log-dir',$logDirectory,'--label','gdmcp')
if ($ShowHost) { $launcherArgs += '--show-host' }
$launcherArgs += '--'
$launcherArgs += $GdmcpPath
$launcherArgs += $GdmcpArguments
try {
  $launcherOutput = (& $Python @launcherArgs 2>&1 | Out-String).Trim()
  $launcherExit = $LASTEXITCODE
  $launcherRecord = $null
  try { $launcherRecord = $launcherOutput | ConvertFrom-Json } catch {}
  if ($null -eq $launcherRecord -or [string]::IsNullOrWhiteSpace([string]$launcherRecord.record)) {
    Fail "background GDMCP launcher did not produce a session record (exit $launcherExit): $launcherOutput" $launcherExit
  }
  $sessionRecord = [string]$launcherRecord.record
  $session = Get-Content -LiteralPath $sessionRecord -Raw | ConvertFrom-Json
  $stdout = Read-Log ([string]$session.stdout)
  $stderr = Read-Log ([string]$session.stderr)
  $exitCode = $session.child_exit_code
  Write-Output 'stdout_begin'
  if ($stdout.Length -gt 0) { Write-Output $stdout.TrimEnd() }
  Write-Output 'stdout_end'
  Write-Output 'stderr_begin'
  if ($stderr.Length -gt 0) { [Console]::Error.WriteLine($stderr.TrimEnd()) }
  Write-Output 'stderr_end'
  Write-Audit 'session_record' $sessionRecord
  Write-Audit 'stdout_log' ([string]$session.stdout)
  Write-Audit 'stderr_log' ([string]$session.stderr)
  Write-Audit 'launcher_exit_code' ([string]$session.launcher_exit_code)
  Write-Audit 'exit_code' ([string]$exitCode)
  if ($session.status -eq 'blocked') { Fail "GDMCP child blocked: $($session.error); session: $sessionRecord" ([int]$session.launcher_exit_code) }
  if ($null -eq $exitCode) { Fail "GDMCP child exit code missing; session: $sessionRecord" ([int]$session.launcher_exit_code) }
  if ([int]$exitCode -ne 0) { exit ([int]$exitCode) }
  exit 0
} catch {
  Fail ("GDMCP launch failed: " + $_.Exception.Message)
} finally {
  # Logs remain in the temp directory so the action evidence is recoverable.
}
