return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "-j=4",
    "--completion-style=detailed"
  },

  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
  },

  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    "CMakeLists.txt",
    ".clangd",
    ".git",
  },
}
