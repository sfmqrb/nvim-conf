-- Full vimtex setup + LaTeX snippets, merged from github.com/sfmqrb/nvim-conf.
-- Overrides the vimtex spec from the lang.tex extra. The `config` below also
-- repeats what that extra did (disable `K`, pick a quickfix method) since
-- lazy.nvim keeps only the last `config` function.
return {
  "lervag/vimtex",
  lazy = false,
  dependencies = { "L3MON4D3/LuaSnip" },
  init = function()
    -- vimtex's version guard wants nvim >= 0.12.4; older dev builds are fine.
    vim.g.vimtex_version_check = 0

    -- Viewer. Swap to zathura (+ zathura-pdf-poppler) for synctex forward/inverse
    -- search, then set vimtex_view_method = "zathura".
    vim.g.vimtex_view_method = "general"
    vim.g.vimtex_view_general_viewer = "evince"

    -- Prefer a user-local TeX Live 2025 if present (matches Overleaf's image).
    local tl2025 = vim.fn.expand("~/texlive/2025/bin/x86_64-linux")
    if vim.fn.isdirectory(tl2025) == 1 then
      vim.env.PATH = tl2025 .. ":" .. vim.env.PATH
    end

    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-shell-escape",
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }

    -- Auto-open quickfix on errors, not on warnings, and don't steal focus.
    vim.g.vimtex_quickfix_mode = 2
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtex_quickfix_ignore_filters = {
      "Underfull",
      "Overfull",
      "specifier changed to",
      "Token not allowed in a PDF string",
    }

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
    -- from the lang.tex extra:
    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
    vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"

    -- Start continuous compilation when a LaTeX file opens (so every :w
    -- recompiles). <leader>lc toggles it off/on.
    vim.api.nvim_create_autocmd("User", {
      pattern = "VimtexEventInitPost",
      command = "VimtexCompile",
    })

    -- LaTeX snippets (expand / jump with <Tab>/<S-Tab>)
    local ls = require("luasnip")
    local s = ls.snippet
    local i = ls.insert_node
    local t = ls.text_node
    local rep = require("luasnip.extras").rep

    ls.add_snippets("tex", {
      s("beg", {
        t("\\begin{"), i(1, "env"), t({ "}", "\t" }), i(0),
        t({ "", "\\end{" }), rep(1), t("}"),
      }),
      s("eq", { t({ "\\begin{equation}", "\t" }), i(0), t({ "", "\\end{equation}" }) }),
      s("ali", { t({ "\\begin{align}", "\t" }), i(0), t({ "", "\\end{align}" }) }),
      s("it", { t({ "\\begin{itemize}", "\t\\item " }), i(0), t({ "", "\\end{itemize}" }) }),
      s("en", { t({ "\\begin{enumerate}", "\t\\item " }), i(0), t({ "", "\\end{enumerate}" }) }),
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
      s("mm", { t("$"), i(1), t("$") }),
      s("dm", { t({ "\\[", "\t" }), i(1), t({ "", "\\]" }) }),
      s("ff", { t("\\frac{"), i(1), t("}{"), i(2), t("}") }),
      s("sum", { t("\\sum_{"), i(1, "i=1"), t("}^{"), i(2, "n"), t("} ") }),
      s("int", { t("\\int_{"), i(1), t("}^{"), i(2), t("} ") }),
      s("lim", { t("\\lim_{"), i(1, "n \\to \\infty"), t("} ") }),
      s("sec", { t("\\section{"), i(1), t("}") }),
      s("sub", { t("\\subsection{"), i(1), t("}") }),
      s("ssub", { t("\\subsubsection{"), i(1), t("}") }),
      s("bf", { t("\\textbf{"), i(1), t("}") }),
      s("em", { t("\\emph{"), i(1), t("}") }),
      s("tt", { t("\\texttt{"), i(1), t("}") }),
      s("up", { t("\\usepackage{"), i(1), t("}") }),
      s("doc", {
        t({
          "\\documentclass[11pt]{article}", "", "\\usepackage[utf8]{inputenc}",
          "\\usepackage{amsmath, amssymb}", "\\usepackage{graphicx}", "\\usepackage{hyperref}",
          "", "\\title{",
        }), i(1, "Title"),
        t({ "}", "\\author{" }), i(2, "Author"),
        t({ "}", "\\date{\\today}", "", "\\begin{document}", "", "\\maketitle", "", "" }),
        i(0),
        t({ "", "", "\\end{document}" }),
      }),
    })
  end,
}
