-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("neo-tree").setup({
				source_selector = {
					winbar = false,
					statusline = false,
					show_scrolled_off_parent_node = false,
					sources = {
						{ source = "filesystem", display_name = " 󰉓 Files " },
						{ source = "buffers", display_name = " 󰈚 Buffers " },
						{ source = "git_status", display_name = " 󰊢 Git " },
					},
					content_layout = "start",
					tabs_layout = "equal",
					truncation_character = "…",
					tabs_min_width = nil,
					tabs_max_width = nil,
					padding = 0,
					separator = { left = "▏", right = "▕" },
					separator_active = nil,
					show_separator_on_edge = false,
					highlight_tab = "NeoTreeTabInactive",
					highlight_tab_active = "NeoTreeTabActive",
					highlight_background = "NeoTreeTabInactive",
					highlight_separator = "NeoTreeTabSeparatorInactive",
					highlight_separator_active = "NeoTreeTabSeparatorActive",
				},
			})
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	{
		"s1n7ax/nvim-window-picker",
		version = "2.*",
		config = function()
			require("window-picker").setup({
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					bo = {
						filetype = { "neo-tree", "neo-tree-popup", "notify" },
						buftype = { "terminal", "quickfix" },
					},
				},
			})
		end,
	},
}
