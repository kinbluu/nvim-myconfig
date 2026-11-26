vim.api.nvim_create_user_command("PackAdd", function(opts)
	vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Install and load plugins from URLs" })

vim.api.nvim_create_user_command("PackDel", function(opts)
	vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete inactive plugins by name" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
	vim.pack.update(#opts.fargs > 0 and opts.fargs or nil)
end, { nargs = "*", desc = "Review updates for selected plugins or all plugins" })

vim.api.nvim_create_user_command("PackCheck", function()
	local inactive = vim.iter(vim.pack.get(nil, { info = false }))
		:filter(function(plugin)
			return not plugin.active
		end)
		:map(function(plugin)
			return plugin.spec.name
		end)
		:totable()

	if #inactive == 0 then
		vim.notify("All installed plugins are active")
		return
	end

	table.sort(inactive)
	local prompt = "Inactive plugins:\n" .. table.concat(inactive, "\n") .. "\n\nDelete these plugins from disk?"
	if vim.fn.confirm(prompt, "&Yes\n&No", 2) == 1 then
		vim.pack.del(inactive)
		vim.notify(("Deleted %d inactive plugin(s)"):format(#inactive))
	end
end, { desc = "Review inactive plugins for deletion" })
