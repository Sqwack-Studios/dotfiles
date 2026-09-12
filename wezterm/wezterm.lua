local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local target = wezterm.target_triple

if target:find("windows") then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
elseif target:find("darwin") then
	config.default_prog = { "/bin/zsh", "-l" }
elseif target:find("linux") then
	config.default_prog = { "/bin/bash", "-l" }
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

config.keys = {
    {
        key = 't',
        mods = 'CTRL',
        action = wezterm.action.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 'w',
        mods = 'CTRL',
        action = wezterm.action.CloseCurrentTab { confirm = false },
    },

}

return config
