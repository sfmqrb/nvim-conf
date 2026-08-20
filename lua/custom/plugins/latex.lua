return {
    "lervag/vimtex",
    lazy = false, -- vimtex should not be lazy-loaded (it handles ft detection itself)
    init = function()
        -- This nvim is a 0.12.0-dev build; vimtex's guard wants >= 0.12.4 but works fine here
        vim.g.vimtex_version_check = 0

        -- Viewer: evince is what's installed on this machine.
        -- (Install zathura + zathura-pdf-poppler for proper synctex forward/inverse search,
        --  then change this to: vim.g.vimtex_view_method = "zathura")
        vim.g.vimtex_view_method = "general"
        vim.g.vimtex_view_general_viewer = "evince"

        -- Compile with latexmk (continuous mode: recompiles on every save)
        vim.g.vimtex_compiler_method = "latexmk"

        -- Auto-open quickfix on compile errors (but not on warnings, and don't steal focus)
        vim.g.vimtex_quickfix_mode = 2
        vim.g.vimtex_quickfix_open_on_warning = 0
        vim.g.vimtex_quickfix_ignore_filters = {
            "Underfull",
            "Overfull",
            "specifier changed to",
            "Token not allowed in a PDF string",
        }

        -- Nicer in-buffer rendering of math symbols etc. (conceallevel set in ftplugin/tex.lua)
        vim.g.vimtex_syntax_conceal = {
            accents = 1,
            ligatures = 1,
            cites = 1,
            fancy = 1,
            spacing = 0,
            greek = 1,
            math_bounds = 1,
            math_delimiters = 1,
            math_fracs = 1,
            math_super_sub = 1,
            math_symbols = 1,
            sections = 0,
            styles = 1,
        }
    end,
    config = function()
        -- Start continuous compilation automatically when a LaTeX file is opened,
        -- so every :w recompiles. <space>lc toggles it off/on.
        vim.api.nvim_create_autocmd("User", {
            pattern = "VimtexEventInitPost",
            command = "VimtexCompile",
        })

        -- LaTeX snippets (expand with <Tab>, jump between fields with <Tab>/<S-Tab>)
        local ls = require("luasnip")
        local s = ls.snippet
        local i = ls.insert_node
        local t = ls.text_node
        local rep = require("luasnip.extras").rep

        ls.add_snippets("tex", {
            -- environments
            s("beg", {
                t("\\begin{"), i(1, "env"), t({ "}", "\t" }), i(0),
                t({ "", "\\end{" }), rep(1), t("}"),
            }),
            s("eq", {
                t({ "\\begin{equation}", "\t" }), i(0),
                t({ "", "\\end{equation}" }),
            }),
            s("ali", {
                t({ "\\begin{align}", "\t" }), i(0),
                t({ "", "\\end{align}" }),
            }),
            s("it", {
                t({ "\\begin{itemize}", "\t\\item " }), i(0),
                t({ "", "\\end{itemize}" }),
            }),
            s("en", {
                t({ "\\begin{enumerate}", "\t\\item " }), i(0),
                t({ "", "\\end{enumerate}" }),
            }),
            s("fig", {
                t({ "\\begin{figure}[htbp]", "\t\\centering", "\t\\includegraphics[width=" }),
                i(1, "0.8"), t("\\textwidth]{"), i(2, "path"),
                t({ "}", "\t\\caption{" }), i(3, "caption"),
                t({ "}", "\t\\label{fig:" }), i(4, "label"),
                t({ "}", "\\end{figure}" }),
            }),
            s("tab", {
                t("\\begin{table}[htbp]\n\t\\centering\n\t\\begin{tabular}{"), i(1, "lcc"),
                t({ "}", "\t\t" }), i(0),
                t({ "", "\t\\end{tabular}", "\t\\caption{" }), i(2, "caption"),
                t({ "}", "\t\\label{tab:" }), i(3, "label"),
                t({ "}", "\\end{table}" }),
            }),
            -- math
            s("mm", { t("$"), i(1), t("$") }),
            s("dm", { t({ "\\[", "\t" }), i(1), t({ "", "\\]" }) }),
            s("ff", { t("\\frac{"), i(1), t("}{"), i(2), t("}") }),
            s("sum", { t("\\sum_{"), i(1, "i=1"), t("}^{"), i(2, "n"), t("} ") }),
            s("int", { t("\\int_{"), i(1), t("}^{"), i(2), t("} ") }),
            s("lim", { t("\\lim_{"), i(1, "n \\to \\infty"), t("} ") }),
            -- sectioning
            s("sec", { t("\\section{"), i(1), t("}") }),
            s("sub", { t("\\subsection{"), i(1), t("}") }),
            s("ssub", { t("\\subsubsection{"), i(1), t("}") }),
            -- text styling
            s("bf", { t("\\textbf{"), i(1), t("}") }),
            s("em", { t("\\emph{"), i(1), t("}") }),
            s("tt", { t("\\texttt{"), i(1), t("}") }),
            -- misc
            s("up", { t("\\usepackage{"), i(1), t("}") }),
            s("doc", {
                t({ "\\documentclass[11pt]{article}", "", "\\usepackage[utf8]{inputenc}",
                    "\\usepackage{amsmath, amssymb}", "\\usepackage{graphicx}", "\\usepackage{hyperref}",
                    "", "\\title{" }), i(1, "Title"),
                t({ "}", "\\author{" }), i(2, "Author"),
                t({ "}", "\\date{\\today}", "", "\\begin{document}", "", "\\maketitle", "", "" }),
                i(0),
                t({ "", "", "\\end{document}" }),
            }),
        })
    end,
}
