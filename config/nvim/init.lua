-- =============================================================================
-- VimTeX / Folding 設定 (プラグイン読み込み前に追加)
-- =============================================================================
vim.g.vimtex_fold_enabled = 1

-- 見出し（\chapter, \section, \subsection 等）の階層フォールドを有効化
vim.g.vimtex_fold_types = {
  sections = { parse_levels = 1 },
}

-- ファイルを開いたときにすべて折りたたまれるのを防ぐ（初期状態は全展開）
vim.opt.foldlevel = 99

-- =============================================================================
-- プラグイン管理 (vim.pack)
-- =============================================================================
vim.pack.add({
  "https://github.com/tpope/vim-sensible",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/tpope/vim-surround",
  "https://github.com/tpope/vim-dadbod",
  "https://github.com/lervag/vimtex",
  "https://github.com/anekos/hledger-vim",
  "https://github.com/jamessan/vim-gnupg",
  "https://github.com/andymass/vim-matchup",
  "https://github.com/fatih/vim-go",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/kristijanhusak/vim-dadbod-completion",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/hrsh7th/nvim-cmp",
  -- "https://github.com/shougo/ddc.vim", -- nvim-cmp と併用しない場合はコメントアウト推奨
})

-- =============================================================================
-- 基本オプション
-- =============================================================================
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.statusline = "%f"
vim.opt.shellredir = ">"
vim.opt.syntax = "on"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tags = "./tags;,tags;" -- カレントから上位へ tags を探索
vim.opt.complete:append("t")

-- =============================================================================
-- 外部連携 (vim-dadbod)
-- =============================================================================
vim.g.dbs = {
  the_world = "postgresql://parorafia@localhost:5432/the_world",
}

-- =============================================================================
-- augroup: templates
-- =============================================================================
local templates_grp = vim.api.nvim_create_augroup("templates", { clear = true })

vim.api.nvim_create_autocmd("BufNewFile", {
  group = templates_grp,
  pattern = "*.tex",
  command = "0r ~/.my/templates/lualatex.tex.m4",
})

-- =============================================================================
-- augroup: fileTypeIndent
-- =============================================================================
local ft_indent_grp = vim.api.nvim_create_augroup("fileTypeIndent", { clear = true })

local function ft(opts)
  vim.api.nvim_create_autocmd("FileType", {
    group = ft_indent_grp,
    pattern = opts.ft,
    callback = function()
      vim.opt_local.shiftwidth  = opts.sw
      vim.opt_local.softtabstop = opts.sts
      vim.opt_local.tabstop     = opts.ts
      vim.opt_local.expandtab   = opts.et
    end,
  })
end

-- 不可視文字の表示を有効化
vim.opt.list = true

-- 表示する記号のカスタマイズ
vim.opt.listchars = {
  tab = "» ",       -- タブ文字: 先頭に »、以降スペースで埋める (または "▸ ", "→ " など)
  trail = "·",      -- 行末の余計な空白
  nbsp = "␣",       -- ノーブレークスペース
  extends = "›",    -- wrap=false 時に右へはみ出した文字
  precedes = "‹",   -- wrap=false 時に左へはみ出した文字
}

-- 各種インデント設定（'js' は無効なため 'javascript' に統一）
ft { ft = "c",          sw = 4, sts = 4, ts = 4, et = true }
ft { ft = "html",       sw = 4, sts = 4, ts = 4, et = true }
ft { ft = "ruby",       sw = 2, sts = 2, ts = 2, et = true }
ft { ft = "zsh",        sw = 4, sts = 4, ts = 4, et = true }
ft { ft = "python",     sw = 4, sts = 4, ts = 4, et = true }
ft { ft = "scala",      sw = 4, sts = 4, ts = 4, et = true }
ft { ft = "json",       sw = 4, sts = 4, ts = 4, et = true }
ft { ft = "css",        sw = 4, sts = 4, ts = 4, et = true }
ft { ft = "scss",       sw = 4, sts = 4, ts = 4, et = true }
ft { ft = "sass",       sw = 4, sts = 4, ts = 4, et = true }
ft { ft = "javascript", sw = 2, sts = 2, ts = 2, et = true }
ft { ft = "typescript", sw = 2, sts = 2, ts = 2, et = true }
ft { ft = "haskell",    sw = 2, sts = 2, ts = 2, et = true }

-- 特殊ファイル
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = ft_indent_grp,
  pattern = "*.tsv",
  callback = function()
    vim.opt_local.shiftwidth  = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop     = 12
    vim.opt_local.expandtab   = false
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = ft_indent_grp,
  pattern = "TODO",
  callback = function()
    vim.opt_local.tabstop   = 12
    vim.opt_local.expandtab = false
  end,
})

-- LaTeX スペルチェック（日本語除外）
vim.api.nvim_create_autocmd("FileType", {
  group = ft_indent_grp,
  pattern = "tex",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en", "cjk" }
  end,
})

-- =============================================================================
-- ユーティリティ: 区切り線コメントの挿入
-- =============================================================================
local function insert_comment_divider(char, total_len)
  char = char or "="
  total_len = total_len or 80

  local cs = vim.bo.commentstring
  if cs == "" then cs = "%s" end

  local prefix = cs:match("^(.-)%%s") or "% "
  prefix = vim.trim(prefix) .. " "

  local repeat_count = math.max(0, total_len - #prefix)
  local line = prefix .. string.rep(char, repeat_count)

  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, { line })
  vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
end

vim.keymap.set("n", "<leader>cl", function()
  insert_comment_divider("=", 80)
end, { desc = "Insert heavy comment divider" })

vim.keymap.set("n", "<leader>c-", function()
  insert_comment_divider("-", 80)
end, { desc = "Insert light comment divider" })
