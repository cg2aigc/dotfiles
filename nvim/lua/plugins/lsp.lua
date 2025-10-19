return {
	-- tools
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed or {}, {
        -- 语言服务器
        "typescript-language-server",
        "tailwindcss-language-server",
        -- "css-lsp",
        "html-lsp",
        -- "emmet-ls",
        "vue-language-server",  -- 如需 Vue

        -- 格式化工具
        "prettier",
        "prettierd",  -- 更快的 Prettier

        -- Linting 工具
        "eslint_d",   -- 更快的 ESLint
        "stylelint",  -- CSS Linter

        -- 其他
        "js-debug-adapter",


				-- "luacheck",
				-- "shellcheck",
				-- "shfmt",
			})
		end,
	},

	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = true },
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
			servers = {
        -- Tailwind CSS
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(
              "tailwind.config.js",
              "tailwind.config.ts",
              "postcss.config.js",
              "postcss.config.ts",
              ".git"
            )(...)
          end,
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                },
              },
            },
          },
        },

        -- TypeScript (LazyVim extras 已配置,这里仅覆盖特定选项)
        -- tsserver = {
        --   -- 如需自定义 tsserver,取消注释
        -- },

        -- CSS
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            less = {
              validate = true,
            },
          },
        },

        -- HTML
        html = {
          filetypes = { "html", "htmldjango" },
        },

        -- Emmet LSP (HTML/CSS 快速扩展)
        -- emmet_ls = {
        --   filetypes = {
        --     "html", "css", "scss", "sass", "less",
        --     "javascriptreact", "typescriptreact",
        --     "vue", "svelte",
        --   },
        -- },

        -- Vue 
        vue_ls = { enabled = false },
        volar = {
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
          diagnostic = false,
        },

        -- ESLint 作为 LSP (额外的诊断)
        eslint = {
          settings = {
            workingDirectory = { mode = "location" },
          },
        },

				lua_ls = {
					-- enabled = false,
					single_file_support = true,
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								workspaceWord = true,
								callSnippet = "Both",
							},
							misc = {
								parameters = {
									-- "--log-level=trace",
								},
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							doc = {
								privateName = { "^_" },
							},
							type = {
								castNumberToInteger = true,
							},
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								-- enable = false,
								groupSeverity = {
									strong = "Warning",
									strict = "Warning",
								},
								groupFileStatus = {
									["ambiguity"] = "Opened",
									["await"] = "Opened",
									["codestyle"] = "None",
									["duplicate"] = "Opened",
									["global"] = "Opened",
									["luadoc"] = "Opened",
									["redefined"] = "Opened",
									["strict"] = "Opened",
									["strong"] = "Opened",
									["type-check"] = "Opened",
									["unbalanced"] = "Opened",
									["unused"] = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
							format = {
								enable = false,
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
									continuation_indent_size = "2",
								},
							},
						},
					},
				},

			},
			setup = {},
		},
	},
}
