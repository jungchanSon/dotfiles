-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fy", function()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or vim.bo.buftype ~= "" then
    vim.notify("파일이 열린 코드 창에서 사용하세요.", vim.log.levels.WARN)
    return
  end
  path = vim.fn.fnamemodify(path, ":p")
  vim.fn.setreg("+", path)
  vim.notify("파일 경로를 복사했습니다: " .. path)
end, { desc = "Copy Absolute File Path" })
