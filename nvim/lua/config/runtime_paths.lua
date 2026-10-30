local M = {}

local function executable(path)
  return path and path ~= "" and vim.fn.executable(path) == 1
end

-- Explicit override, PATH (including Mason), then standalone installations.
function M.kotlin()
  if executable(vim.env.KOTLIN_LSP_CMD) then
    return vim.env.KOTLIN_LSP_CMD
  end
  for _, name in ipairs({ "kotlin-lsp", "intellij-server" }) do
    local path = vim.fn.exepath(name)
    if executable(path) then
      return path
    end
  end
  local candidates = vim.fn.globpath(
    vim.fn.stdpath("data") .. "/../kotlin-lsp", "kotlin-server-*/bin/intellij-server", false, true
  )
  table.sort(candidates, function(a, b)
    local av = a:match("kotlin%-server%-([%d.]+)")
    local bv = b:match("kotlin%-server%-([%d.]+)")
    return vim.version.lt(bv, av)
  end)
  for _, path in ipairs(candidates) do
    if executable(path) then
      return path
    end
  end
end

local function java_home(path)
  if not path or path == "" then
    return
  end
  local binary = path .. "/bin/" .. (vim.fn.has("win32") == 1 and "java.exe" or "java")
  local release = path .. "/release"
  if not executable(binary) or vim.fn.filereadable(release) ~= 1 then
    return
  end
  local text = table.concat(vim.fn.readfile(release), "\n")
  local major = tonumber(text:match('JAVA_VERSION="(%d+)'))
  if major and major >= 25 then
    return path
  end
end

-- Only the Java language server needs JDK 25; project toolchains stay unchanged.
function M.jdtls_java_home()
  for _, path in ipairs({ vim.env.JDTLS_JAVA_HOME or "", vim.env.JAVA_HOME or "" }) do
    local home = java_home(path)
    if home then
      return home
    end
  end
  if vim.fn.has("mac") == 1 and executable("/usr/libexec/java_home") then
    local path = vim.fn.system({ "/usr/libexec/java_home", "-v", "25+" })
    if vim.v.shell_error == 0 then
      local home = java_home(vim.trim(path))
      if home then
        return home
      end
    end
  end
  local binary = vim.fn.exepath("java")
  local real = binary ~= "" and vim.uv.fs_realpath(binary) or nil
  if real then
    return java_home(vim.fs.dirname(vim.fs.dirname(real)))
  end
end

return M
