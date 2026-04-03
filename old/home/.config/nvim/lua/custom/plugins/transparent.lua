return {
	{
		"xiyaowong/transparent.nvim",
		config = function()
			-- Optional, you don't have to run setup.
			require("transparent").setup({
				-- table: additional groups that should be cleared
				extra_groups = {},
				-- table: groups you don't want to clear
				exclude_groups = { "Comment", "CursorLine", "CursorLineNr" },
				-- function: code to be executed after highlight groups are cleared
				-- Also the user event "TransparentClear" will be triggered
				on_clear = function() end,
			})
			vim.cmd("TransparentEnable")
		end,
	},
}
