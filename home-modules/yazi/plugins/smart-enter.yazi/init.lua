return {
	entry = function()
		local h = cx.active.current.hovered
		if h.cha.is_dir then
			ya.manager_emit("enter" or "open", { hovered = true })
			else
				local hx_command = '\'\\e : o ' .. tostring(h.url) .. ' \\r\''
				local command = 'zellij ac focus-next-pane && zellij ac write 27 && zellij ac write-chars ":o flake.nix" && zellij ac write 13' .. 'right ' .. hx_command
				-- local command = 'zellij ac focus-next-pane && zellij ac write 27 && zellij ac write-chars ":o flake.nix" && zellij ac write 13' .. 'right ' .. hx_command
				-- zellij ac focus-next-pane && zellij ac write 27 && zellij ac write-chars ":o flake.nix" && zellij ac write 13
				os.execute(command)
		end
	end,
}
