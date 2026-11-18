param(
    [string]$BuildDirectory = (Join-Path $PSScriptRoot '.build')
)

$ErrorActionPreference = 'Stop'
$sourceCommit = '341f92fb68a51733cb54912ac58f56b5d3072650'
$patch = Join-Path $PSScriptRoot 'pastebar-v0.7.0.patch'
$buildRoot = [IO.Path]::GetFullPath($BuildDirectory)
$source = Join-Path $buildRoot 'upstream'
$portable = Join-Path $buildRoot 'portable'
$env:npm_config_cache = Join-Path $buildRoot 'npm-cache'
$env:CARGO_TARGET_DIR = Join-Path $buildRoot 'target'
$env:CARGO_NET_GIT_FETCH_WITH_CLI = 'true'
$env:TEMP = Join-Path $buildRoot 'temp'
$env:TMP = $env:TEMP

New-Item -ItemType Directory -Path $buildRoot,$env:TEMP -Force | Out-Null
if (-not (Test-Path -LiteralPath $source)) {
    git -c core.longpaths=true clone --branch v0.7.0 --depth 1 https://github.com/PasteBar/PasteBarApp.git $source
    if ($LASTEXITCODE) { throw 'Could not download the PasteBar v0.7.0 source.' }
}

$actualCommit = git -C $source rev-parse HEAD
if ($LASTEXITCODE -or $actualCommit -ne $sourceCommit) {
    throw 'The checkout does not match the tested PasteBar v0.7.0 commit.'
}

git -C $source apply --reverse --check $patch 2>$null
if ($LASTEXITCODE) {
    git -C $source apply --check $patch
    if ($LASTEXITCODE) { throw 'The change does not apply cleanly to this checkout.' }
    git -C $source apply $patch
    if ($LASTEXITCODE) { throw 'Could not apply the change.' }
}

Push-Location -LiteralPath $source
try {
    npm.cmd ci --no-audit --no-fund
    if ($LASTEXITCODE) { throw 'Could not install frontend dependencies.' }
    npm.cmd run build --workspace pastebar-app-ui
    if ($LASTEXITCODE) { throw 'The frontend build failed.' }
    cargo +1.87.0-x86_64-pc-windows-msvc build --release --locked --manifest-path src-tauri/Cargo.toml
    if ($LASTEXITCODE) { throw 'The Windows application build failed.' }
} finally {
    Pop-Location
}

New-Item -ItemType Directory -Path $portable -Force | Out-Null
$executable = Join-Path $portable 'PasteBar.exe'
Copy-Item -LiteralPath (Join-Path $env:CARGO_TARGET_DIR 'release/pastebar-app.exe') -Destination $executable -Force
Write-Output $executable
