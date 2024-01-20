return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        {
            "linrongbin16/lsp-progress.nvim",
            config = function()
                require("lsp-progress").setup({
                    client_format = function(client_name, spinner, series_messages)
                        if #series_messages == 0 then
                            return nil
                        end
                        return {
                            name = client_name,
                            body = spinner .. " " .. table.concat(series_messages, ", "),
                        }
                    end,
                    format = function(client_messages)
                        --- @param name string
                        --- @param msg string?
                        --- @return string
                        local function stringify(name, msg)
                            return msg and string.format("%s %s", name, msg) or name
                        end

                        local sign = "" -- nf-fa-gear \uf013
                        local lsp_clients = vim.lsp.get_active_clients()
                        local messages_map = {}
                        for _, climsg in ipairs(client_messages) do
                            messages_map[climsg.name] = climsg.body
                        end

                        if #lsp_clients > 0 then
                            table.sort(lsp_clients, function(a, b)
                                return a.name < b.name
                            end)
                            local builder = {}
                            for _, cli in ipairs(lsp_clients) do
                                if
                                    type(cli) == "table"
                                    and type(cli.name) == "string"
                                    and string.len(cli.name) > 0
                                then
                                    if messages_map[cli.name] then
                                        table.insert(
                                            builder,
                                            stringify(cli.name, messages_map[cli.name])
                                        )
                                    else
                                        table.insert(builder, stringify(cli.name))
                                    end
                                end
                            end
                            if #builder > 0 then
                                return sign .. " " .. table.concat(builder, ", ")
                            end
                        end
                        return ""
                    end,
                })
                require('lsp-progress').progress({
                    format = function(client_messages)
                        local sign = " LSP" -- nf-fa-gear \uf013
                        if #client_messages > 0 then
                            return sign .. " " .. table.concat(client_messages, " ")
                        end
                        if #vim.lsp.get_active_clients() > 0 then
                            return sign
                        end
                        return ""
                    end,
                    max_size = -1,
                    spinner = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
                })
            end
        }
    },
    config = function()
        local lualine = require("lualine")

        local colors = {
            blue = "#65D1FF",
            green = "#3EFFDC",
            violet = "#FF61EF",
            yellow = "#FFDA7B",
            red = "#FF4A4A",
            fg = "#c3ccdc",
            bg = "#112638",
            inactive_bg = "#2c3043",
        }

        local my_lualine_theme = {
            normal = {
                a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            insert = {
                a = { bg = colors.green, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            visual = {
                a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            command = {
                a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            replace = {
                a = { bg = colors.red, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            inactive = {
                a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
                b = { bg = colors.inactive_bg, fg = colors.semilightgray },
                c = { bg = colors.inactive_bg, fg = colors.semilightgray },
            },
        }

        -- configure lualine with modified theme
        lualine.setup({
            options = {
                theme = my_lualine_theme,
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = {
                    { "filename" },
                    { "require('lsp-progress').progress()" },
                },
                lualine_x = {
                    { "encoding" },
                    { "fileformat" },
                    { "filetype" },
                },
            },
        })

        -- listen lsp-progress event and refresh lualine
        vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
        vim.api.nvim_create_autocmd("User", {
            group = "lualine_augroup",
            pattern = "LspProgressStatusUpdated",
            callback = require("lualine").refresh,
        })
    end,
}
