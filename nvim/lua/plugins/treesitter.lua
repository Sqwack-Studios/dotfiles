return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',

  config = function()
      local ts = require('nvim-treesitter')

      local parsers = {
      "asm",
      "c",
      "cpp",
      "cuda",
      "hlsl",
      "glsl",
      "json",
      "rust",
      "lua",
      "markdown",
      "markdown_inline",}

      local filetypes = {
      "asm",
      "c",
      "cpp",
      "cuda",
      "hlsl",
      "glsl",
      "json",
      "rust",
      "lua",
      "markdown",}
      

      ts.install(parsers)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,})
  end
}
