return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
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
      

      -- Only install what is missing. Calling install() unconditionally
      -- re-triggers a download on every startup for anything not yet built.
      local installed = require('nvim-treesitter.config').get_installed('parsers')
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, parsers)

      if #missing > 0 then
        ts.install(missing)
      end
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,})
  end
}
