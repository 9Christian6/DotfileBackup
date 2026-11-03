local M = {}
local border_style = "rounded"

-- Add your LTEX dictionaries here.
-- The keys are LanguageTool language codes.
local ltex_dictionary = {
	["en-US"] = {
		-- Add English words here, e.g.:
		"Neovim",
	},
	["de-DE"] = {
		-- Add German words here, e.g.:
		"Neovim",
	},
}

local function setup_float_style()
	local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
	local normal_bg = normal.bg
	local normal_fg = normal.fg

	vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal_bg, fg = normal_fg })
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#FF00FF", bg = normal_bg })
	vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#FF00FF", bg = normal_bg, bold = true })

	vim.api.nvim_set_hl(0, "Pmenu", { bg = normal_bg, fg = normal_fg })
	vim.api.nvim_set_hl(0, "PmenuSbar", { bg = normal_bg })
	vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#FF00FF" })

	pcall(function()
		vim.o.winborder = border_style
	end)
end

local function setup_lsp_handlers()
	vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
		config = vim.tbl_deep_extend("force", config or {}, {
			border = border_style,
			max_height = 50,
			max_width = math.floor(vim.o.columns * 0.6),
		})
		return vim.lsp.handlers.hover(err, result, ctx, config)
	end

	vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
		config = vim.tbl_deep_extend("force", config or {}, {
			border = border_style,
			max_height = 50,
			max_width = math.floor(vim.o.columns * 0.6),
		})
		return vim.lsp.handlers.signature_help(err, result, ctx, config)
	end
end

local function make_capabilities()
	local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if ok then
		return cmp_nvim_lsp.default_capabilities()
	end
	return vim.lsp.protocol.make_client_capabilities()
end

local function on_attach(client, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	local ok, navic = pcall(require, "nvim-navic")
	if ok and client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end
end

local lspconfig_util = require("lspconfig.util")
local unpack = table.unpack or unpack

local server_overrides = {
	pyright = function(config)
		return vim.tbl_deep_extend("force", config, {
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
						pythonPath = "/home/christian/Opt/PythonEnvs/myVirtualEnv/bin/python3.12",
					},
				},
			},
		})
	end,

	ruff = function(config)
		config.on_attach = function(client, bufnr)
			client.server_capabilities.hoverProvider = false
			client.server_capabilities.documentFormattingProvider = false
			on_attach(client, bufnr)
		end
		return config
	end,

	bacon_ls = function(config)
		config.filetypes = { "rust" }
		return config
	end,

	lua_ls = function(config)
		return vim.tbl_deep_extend("force", config, {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})
	end,

	ltex = function(config)
		return vim.tbl_deep_extend("force", config, {
			settings = {
				ltex = {
					-- Automatically detect the document language.
					-- This allows English and German documents to work.
					-- language = "auto",

					-- If your ltex-ls version supports language lists, you can also use:
					-- language = "de-DE",
					language = "auto",

					dictionary = ltex_dictionary,
				},
			},
		})
	end,
	rust_analyzer = function(config)
		return vim.tbl_deep_extend("force", config, {
			settings = {
				["rust-analyzer"] = {
					check = {
						command = "clippy",
					},
					cargo = {
						allFeatures = false,
					},
					diagnostics = {
						enable = true,
					},
				},
			},
		})
	end,
}

local function apply_server_override(server_name, base_config)
	local override = server_overrides[server_name]
	if not override then
		return base_config
	end
	return override(base_config)
end

local function setup_diagnostics()
	vim.diagnostic.config({
		float = {
			border = border_style,
			source = "always",
			header = "",
			prefix = "",
			max_height = 50,
			max_width = math.floor(vim.o.columns * 0.6),
		},
	})
end

local ensured_servers = {
	"clangd",
	"texlab",
	"pyright",
	"ruff",
	"biome",
	"lua_ls",
	"ltex",
	"rust_analyzer",
}

local function define_server_configs(capabilities)
	for _, server_name in ipairs(ensured_servers) do
		local server_config = apply_server_override(server_name, {
			capabilities = capabilities,
			on_attach = on_attach,
		})

		vim.lsp.config(server_name, server_config)
		vim.lsp.enable(server_name)
	end
end

local function setup_mason(capabilities)
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	local mason_lspconfig = require("mason-lspconfig")
	mason_lspconfig.setup({
		ensure_installed = ensured_servers,
		automatic_enable = true,
	})

	define_server_configs(capabilities)
end

function M.setup()
	local float_style_group = vim.api.nvim_create_augroup("FloatStyle", { clear = true })

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = float_style_group,
		callback = setup_float_style,
	})

	setup_float_style()
	setup_lsp_handlers()
	setup_diagnostics()
	setup_mason(make_capabilities())
end

return M
