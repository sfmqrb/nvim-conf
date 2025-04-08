return {
    "mhartington/formatter.nvim",
    config = function()
        require("formatter").setup({
            logging = false,
            filetype = {
                python = {
                    function()
                        return {
                            exe = "black",
                            args = { "-" },
                            stdin = true,
                        }
                    end,
                },
                cpp = {
                    function()
                        return {
                            exe = "clang-format",
                            args = {
                                "--assume-filename",
                                vim.api.nvim_buf_get_name(0),
                                "-style='{BasedOnStyle: llvm, IndentWidth: 4, TabWidth: 4, UseTab: Never}'",
                            },
                            stdin = true,
                        }
                    end,
                },
                lua = {
                    function()
                        return {
                            exe = "stylua",
                            args = {
                                "--search-parent-directories",
                                "--indent-width",
                                "4",
                                "--indent-type",
                                "Spaces",
                                "--stdin-filepath",
                                vim.api.nvim_buf_get_name(0),
                                "--",
                                "-",
                            },
                            stdin = true,
                        }
                    end,
                },
            },
        })
    end,
}
