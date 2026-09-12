#!/usr/bin/env pwsh
#
# Link this repo's configs into the locations nvim and wezterm read from.
#
#   .\install.ps1
#
# Safe to re-run
#
# Uses directory junctions rather than symlinks. A junction gives the same
# result for a local directory but needs no Administrator rights and no
# Developer Mode, which a Windows symlink does.
#

# Where an existing link points, or $null if the item is not a link at all.
# PowerShell 6+ exposes LinkTarget as a string; 5.1 exposes Target as an array.
function Get-LinkTarget {
    param($Item)

    if (-not $Item.LinkType) {
        return $null
    }

    if (($Item.PSObject.Properties.Name -contains 'LinkTarget') -and $Item.LinkTarget) {
        return $Item.LinkTarget
    }

    return @($Item.Target)[0]
}

function Install-ConfigLink {
    param(
        [string]$Name,
        [string]$Dest
    )

    $src = Join-Path $RepoDir $Name

    Write-Host $Dest
    Write-Host "  -> $src"

    if (-not (Test-Path $src)) {
        Write-Host "    skip: not present in repo`n"
        return
    }

    # -Force so hidden items are seen too; SilentlyContinue so a missing
    # target is $null rather than an error.
    $existing = Get-Item $Dest -Force -ErrorAction SilentlyContinue

    if ($existing) {
        # Already the link we want: nothing to do. String -eq is
        # case-insensitive in PowerShell, which suits Windows paths.
        $target = Get-LinkTarget $existing
        if ($target -and ($target.TrimEnd('\') -eq $src.TrimEnd('\'))) {
            Write-Host "    ok: already linked`n"
            return
        }

        # A real file/dir, or a link pointing somewhere else, is in the way.
        # Refuse to touch it; moving it is the user's call.
        [Console]::Error.WriteLine("    ERROR: $Dest already exists")
        [Console]::Error.WriteLine("    move or remove it, then re-run")
        exit 1
    }

    $parent = Split-Path $Dest -Parent
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    New-Item -ItemType Junction -Path $Dest -Target $src | Out-Null
    Write-Host "    linked`n"
}


Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# The absolute directory containing this script
$RepoDir = $PSScriptRoot

# Both tools honour XDG_CONFIG_HOME when it is set. When it is not, they fall
# back to different places on Windows, so each gets its own default:
#   nvim    -> %LOCALAPPDATA%\nvim
#   wezterm -> %USERPROFILE%\.config\wezterm
if ($env:XDG_CONFIG_HOME) {
    $NvimDest    = Join-Path $env:XDG_CONFIG_HOME 'nvim'
    $WeztermDest = Join-Path $env:XDG_CONFIG_HOME 'wezterm'
} else {
    $NvimDest    = Join-Path $env:LOCALAPPDATA 'nvim'
    $WeztermDest = Join-Path (Join-Path $HOME '.config') 'wezterm'
}



Write-Host "repo:    $RepoDir"
Write-Host "nvim:    $NvimDest"
Write-Host "wezterm: $WeztermDest`n"

Install-ConfigLink -Name 'nvim'    -Dest $NvimDest
Install-ConfigLink -Name 'wezterm' -Dest $WeztermDest

Write-Host 'done'
