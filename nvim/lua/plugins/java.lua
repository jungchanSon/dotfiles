return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      local home = require("config.runtime_paths").jdtls_java_home()
      if home then
        opts.jdtls = opts.jdtls or {}
        opts.jdtls.cmd_env = vim.tbl_extend("force", opts.jdtls.cmd_env or {}, { JAVA_HOME = home })
      end
    end,
  },
}
