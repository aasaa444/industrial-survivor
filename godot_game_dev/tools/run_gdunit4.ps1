[CmdletBinding()]
param(
  [switch]$DryRun,
  [switch]$SelfTest,
  [string]$GodotBinary = 'C:\Users\User\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe',
  [int]$TimeoutSec = 120,
  [string]$ReportDirectory = 'user://toolchain-suite'
)
$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$Runner = 'res://addons/gdUnit4/bin/GdUnitCmdTool.gd'
$Tests = @('res://test/adapter_contract_test.gd','res://test/rules_core_test.gd')
$GodotArgs = @('--headless','--path',$ProjectRoot,'-s',$Runner,'--ignoreHeadlessMode')
foreach ($test in $Tests) { $GodotArgs += @('--add',$test) }
$GodotArgs += @('--report-directory',$ReportDirectory)
function Fail([string]$Message) { Write-Error $Message; exit 2 }
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
$logBase = Join-Path ([IO.Path]::GetTempPath()) ('gdunit4-' + [guid]::NewGuid().ToString('N'))
$stdoutLog = "$logBase.stdout.log"
$stderrLog = "$logBase.stderr.log"
$proc = Start-Process -FilePath $GodotBinary -ArgumentList $GodotArgs -WorkingDirectory $ProjectRoot -RedirectStandardOutput $stdoutLog -RedirectStandardError $stderrLog -PassThru
if (-not $proc.WaitForExit($TimeoutSec * 1000)) { $proc.Kill(); Get-Content $stdoutLog,$stderrLog; Fail "runner timeout after ${TimeoutSec}s" }
Get-Content $stdoutLog,$stderrLog
$proc.Refresh()
$exitCode = [int]$proc.ExitCode
Write-Output "runner_exit_code=$exitCode"
if ($exitCode -ne 0) { Fail "gdUnit4 runner failed; stdout: $stdoutLog; stderr: $stderrLog" }
$summary = (Get-Content $stdoutLog,$stderrLog -Raw)
if ($summary -notmatch 'Overall Summary:.*60 test cases' -or $summary -notmatch 'Executed test cases\s*:\s*\(60/60\)') { Fail "Expected 60-case suite summary not found; full log: $log" }
Write-Output 'SUITE_OK_60_OF_60'
exit 0
