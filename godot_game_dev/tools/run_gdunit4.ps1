[CmdletBinding()]
param(
  [switch]$DryRun,
  [switch]$SelfTest,
  [string]$GodotBinary = 'C:\Users\User\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe',
  [int]$TimeoutSec = 120,
  [string]$ReportDirectory = 'user://toolchain-suite',
  [switch]$ShowHost,
  [string]$PythonPath
)
$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$Runner = 'res://addons/gdUnit4/bin/GdUnitCmdTool.gd'
$Tests = @('res://test/adapter_contract_test.gd','res://test/rules_core_test.gd','res://test/weapon_catalog_test.gd','res://test/multi_weapon_foundation_test.gd','res://test/multi_weapon_adapter_catalog_test.gd')
$GodotArgs = @('--headless','--path',$ProjectRoot,'-s',$Runner,'--ignoreHeadlessMode')
foreach ($test in $Tests) { $GodotArgs += @('--add',$test) }
$GodotArgs += @('--report-directory',$ReportDirectory)
function Fail([string]$Message) { Write-Error $Message; exit 2 }
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
Write-Output "runner_project=$ProjectRoot"
Write-Output "runner_binary=$GodotBinary"
Write-Output "runner_script=$Runner"
Write-Output "runner_tests=$($Tests -join ',')"
Write-Output "runner_timeout_sec=$TimeoutSec"
if (-not (Test-Path -LiteralPath $GodotBinary -PathType Leaf)) { Fail "Godot executable not found: $GodotBinary" }
if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot 'project.godot') -PathType Leaf)) { Fail "project.godot not found under $ProjectRoot" }
if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot 'addons\gdUnit4\bin\GdUnitCmdTool.gd') -PathType Leaf)) { Fail "gdUnit4 runner not found under project" }
$version = (& $GodotBinary --version 2>&1 | Out-String).Trim()
if ($LASTEXITCODE -ne 0) { Fail "Godot --version failed (exit $LASTEXITCODE): $version" }
Write-Output "godot_version=$version"
Write-Output "command=$GodotBinary $($GodotArgs -join ' ')"
if ($DryRun) { Write-Output 'DRY_RUN_OK'; exit 0 }
if ($SelfTest) { Write-Output 'SELF_TEST_OK'; exit 0 }
$logDirectory = Join-Path ([IO.Path]::GetTempPath()) 'new-game-background'
$background = Join-Path $PSScriptRoot 'background_process.py'
if (-not (Test-Path -LiteralPath $background -PathType Leaf)) { Fail "background launcher not found: $background" }
$Python = Resolve-Python $PythonPath
$PythonVersion = (& $Python -c "import sys; print(sys.version.split()[0])" 2>&1 | Out-String).Trim()
Write-Output "python_path=$Python"
Write-Output "python_version=$PythonVersion"
$launcherArgs = @($background,'run','--profile','headless_godot','--cwd',$ProjectRoot,'--log-dir',$logDirectory,'--label','gdunit4','--timeout-seconds',$TimeoutSec)
if ($ShowHost) { $launcherArgs += '--show-host' }
$launcherArgs += '--'
$launcherArgs += $GodotBinary
$launcherArgs += $GodotArgs
$launcherOutput = (& $Python @launcherArgs 2>&1 | Out-String).Trim()
$launcherExit = $LASTEXITCODE
$launcher = $null
try { $launcher = $launcherOutput | ConvertFrom-Json } catch {}
if ($null -eq $launcher -or [string]::IsNullOrWhiteSpace([string]$launcher.record)) { Fail "background gdUnit launcher did not produce a session record (exit $launcherExit): $launcherOutput" }
$session = Get-Content -LiteralPath $launcher.record -Raw | ConvertFrom-Json
$stdoutLog = [string]$session.stdout
$stderrLog = [string]$session.stderr
$stdout = Get-Content -LiteralPath $stdoutLog -Raw
$stderr = Get-Content -LiteralPath $stderrLog -Raw
if ($stdout.Length -gt 0) { Write-Output $stdout.TrimEnd() }
if ($stderr.Length -gt 0) { [Console]::Error.WriteLine($stderr.TrimEnd()) }
Write-Output "runner_session_record=$($launcher.record)"
Write-Output "runner_stdout_log=$stdoutLog"
Write-Output "runner_stderr_log=$stderrLog"
Write-Output "runner_launcher_exit_code=$($session.launcher_exit_code)"
if ($session.status -eq 'blocked') { Fail "gdUnit runner blocked without force-kill: $($session.error); session: $($launcher.record)" ([int]$session.launcher_exit_code) }
$exitCode = $session.child_exit_code
if ($null -eq $exitCode) { Fail "gdUnit child exit code missing; session: $($launcher.record)" ([int]$session.launcher_exit_code) }
Write-Output "runner_exit_code=$exitCode"
if ([int]$exitCode -ne 0) { Write-Error "gdUnit4 runner failed; stdout: $stdoutLog; stderr: $stderrLog"; exit ([int]$exitCode) }
$summary = (Get-Content $stdoutLog,$stderrLog -Raw)
if ($summary -notmatch 'Overall Summary:.*?(\d+) errors \| (\d+) failures') { Fail "gdUnit4 failure summary not found; stdout: $stdoutLog; stderr: $stderrLog" }
$errors = [int]$Matches[1]
$failures = [int]$Matches[2]
if ($errors -ne 0 -or $failures -ne 0) { Fail "gdUnit4 reported $errors errors and $failures failures; stdout: $stdoutLog; stderr: $stderrLog" }
if ($summary -notmatch 'Executed test cases\s*:\s*\((\d+)\/(\d+)\)') { Fail "Executed test case summary not found; stdout: $stdoutLog; stderr: $stderrLog" }
$executed = [int]$Matches[1]
$total = [int]$Matches[2]
if ($executed -ne $total -or $total -lt 1) { Fail "gdUnit4 did not execute every test case ($executed/$total); stdout: $stdoutLog; stderr: $stderrLog" }
Write-Output "SUITE_OK_${executed}_OF_${total}"
exit 0
