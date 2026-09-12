#!/usr/bin/env pwsh
#
# Developer environment for C/C++ work on Windows.
#
# Opt-in by design: plain cmd.exe and pwsh.exe stay clean, and you enter this
# deliberately through bin\dev.cmd.
#
#   dev.cmd             clang64 (default)
#   dev.cmd clang64     MSYS2 CLANG64: clang + libc++ + lld, MinGW-w64 ABI
#   dev.cmd clang-cl    not implemented yet
#   dev.cmd msvc        not implemented yet
#
# Note: nvim's config location is deliberately NOT set here. install.ps1
# junctions %LOCALAPPDATA%\nvim to the repo, so nvim finds its config from
# any shell, not only this one.

param(
    [ValidateSet('clang64', 'clang-cl', 'msvc')]
    [string]$Toolchain = 'clang64'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# --- machine-specific, adjust as needed ----------------------------------
# Root of the MSYS2 installation. The CLANG64 environment lives underneath
# it at <root>\clang64.
$Msys2Root = if ($env:MSYS2_ROOT) { $env:MSYS2_ROOT } else { 'C:\msys64' }
# -------------------------------------------------------------------------

function Add-ToPath {
    param([string]$Dir)

    if (-not (Test-Path $Dir)) {
        Write-Warning "not found, skipping: $Dir"
        return
    }

    $env:PATH = "$Dir;$env:PATH"
}

# MSYS2 CLANG64: clang targeting the MinGW-w64 ABI against UCRT, with libc++,
# libunwind and compiler-rt. Debug info is DWARF, so lldb / lldb-dap work
# natively. Binaries from this toolchain are NOT ABI-compatible with anything
# built by cl.exe or clang-cl.
function Enter-Clang64Env {
    $prefix = Join-Path $Msys2Root 'clang64'

    if (-not (Test-Path $prefix)) {
        throw "MSYS2 CLANG64 not found at $prefix - set MSYS2_ROOT or install msys2."
    }

    # Deliberately only clang64\bin. Adding <root>\usr\bin would put MSYS
    # versions of find.exe, sort.exe and link.exe ahead of the Windows ones
    # and break builds in hard-to-diagnose ways. cmake and ninja installed
    # via pacman land in clang64\bin anyway.
    Add-ToPath (Join-Path $prefix 'bin')

    # Lets pacman and any msys-aware tooling know which environment this is.
    $env:MSYSTEM = 'CLANG64'

    # So CMake and friends pick this toolchain up without a per-project flag.
    $env:CC  = 'clang'
    $env:CXX = 'clang++'
}

# To be filled in later. Note for when that happens: vcvars64.bat is a batch
# file and cannot set variables in a PowerShell process. Use vswhere to locate
# the install, then Import-Module on Common7\Tools\Microsoft.VisualStudio.DevShell.dll
# and call Enter-VsDevShell -VsInstallPath $p -SkipAutomaticLocation
# -DevCmdArguments '-arch=x64 -host_arch=x64'.
function Enter-NotImplemented {
    param([string]$Name)
    throw "toolchain '$Name' is not implemented yet - only clang64 is supported."
}

switch ($Toolchain) {
    'clang64'  { Enter-Clang64Env }
    'clang-cl' { Enter-NotImplemented $Toolchain }
    'msvc'     { Enter-NotImplemented $Toolchain }
}

$env:DEV_TOOLCHAIN = $Toolchain

Write-Host ''
Write-Host "  toolchain: $Toolchain"
foreach ($tool in 'clang', 'clang++', 'clangd', 'lldb', 'lldb-dap', 'cmake', 'ninja') {
    $found = Get-Command $tool -ErrorAction SilentlyContinue
    if ($found) {
        Write-Host ("  {0,-10} {1}" -f $tool, $found.Source)
    } else {
        Write-Host ("  {0,-10} MISSING" -f $tool)
    }
}
Write-Host ''
