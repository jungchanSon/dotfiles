return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local executable = require("config.runtime_paths").kotlin()
      opts.servers = opts.servers or {}
      opts.servers.kotlin_language_server = { enabled = false }
      opts.servers.kotlin_lsp = {
        mason = false,
        enabled = executable ~= nil,
        cmd = executable and { executable, "--stdio" } or nil,
      }
    end,
  },
}
