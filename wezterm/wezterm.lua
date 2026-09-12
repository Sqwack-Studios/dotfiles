local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local target = wezterm.target_triple

-- Only Windows needs an explicit program. On macOS and Linux, leaving
-- default_prog unset makes wezterm use the login shell from the password
-- database, instead of a hardcoded path that may be wrong (Homebrew bash,
-- fish, NixOS, or simply a user whose shell is not zsh).
if target:find("windows") then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
end

config.font = wezterm.font({
	family = "Monaspace Neon",
	harfbuzz_features = {
		"calt=1",
		"clig=1",
		"liga=1",
		"ss01=1","ss02=1","ss03=1","ss04=1","ss05=1","ss06=1","ss07=1","ss08=1","ss09=1"},
	
		weight = "Regular"
})

config.font_size = 12.5

return config
