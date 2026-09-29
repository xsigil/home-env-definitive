vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

vim.lsp.config("gopls", {})
-- bash-language-server (Neovim 0.11+ style)
vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash' },
  root_dir = vim.fs.root(0, { '.git', '.editorconfig' }),
})


vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'bash' },
  callback = function()
    vim.lsp.start({
      name = 'bashls',
    })
  end,
})

-- 1. サーバーのテンプレートを定義 (0.11/0.12 スタイル)
-- ここに cmd や root_dir を含めて「定義」を完成させます
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
    },
  },
})

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
})

vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash', 'zsh' },
  root_dir = vim.fs.root(0, { '.git', '.editorconfig' }),
})

-- 2. 自動起動の設定
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'go', 'sh', 'bash', 'zsh' },
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local server_map = {
      lua = 'lua_ls',
      go = 'gopls',
      sh = 'bashls',
      bash = 'bashls',
      zsh = 'bashls',
    }

    local name = server_map[ft]
    if name then
      -- 0.12 では、config("名前") で登録したものを
      -- そのまま start() に渡す、あるいは enable() する流れが主流です
      vim.lsp.enable(name) 
      -- または
      -- vim.lsp.start(name) -- 最近のNightlyでは名前文字列を受け付けるよう調整されています
    end
  end,
})
