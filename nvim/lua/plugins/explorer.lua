local function show_overflow(picker)
  vim.schedule(function()
    if picker._close_filename_overflow then
      picker._close_filename_overflow()
    end
    local win = picker.list.win.win
    if picker.closed or not win or not vim.api.nvim_win_is_valid(win)
      or vim.api.nvim_get_current_win() ~= win then
      return
    end
    local item = picker:current()
    if not item or not item.file then
      return
    end
    local name = vim.fs.basename(item.file)
    local row = vim.api.nvim_win_get_cursor(win)[1]
    local line = vim.api.nvim_buf_get_lines(picker.list.win.buf, row - 1, row, false)[1] or ""
    local start = line:find(name, 1, true)
    if not start then
      return
    end
    local pos = vim.fn.screenpos(win, row, start)
    local origin = vim.fn.win_screenpos(win)
    local width = vim.fn.strdisplaywidth(name)
    local right = origin[2] + vim.api.nvim_win_get_width(win) - 1
    if pos.col == 0 or pos.row == 0 or pos.col + width - 1 <= right then
      return
    end
    width = math.min(width, vim.o.columns - pos.col + 1)
    if width < 1 then
      return
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { name })
    vim.bo[buf].bufhidden = "wipe"
    local float = vim.api.nvim_open_win(buf, false, {
      relative = "editor", row = pos.row - 1, col = pos.col - 1,
      width = width, height = 1, style = "minimal", border = "none",
      focusable = false, noautocmd = true, zindex = 60,
    })
    vim.wo[float].wrap = false
    vim.wo[float].winhighlight = "Normal:CursorLine"
    picker._filename_overflow = float
  end)
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            layout = { layout = { width = 40, min_width = 40 } },
            on_show = function(picker)
              local function close()
                local win = picker._filename_overflow
                if win and vim.api.nvim_win_is_valid(win) then
                  vim.api.nvim_win_close(win, true)
                end
                picker._filename_overflow = nil
              end
              picker._close_filename_overflow = close
              picker.list.win:on({ "CursorMoved", "BufLeave", "WinLeave", "WinClosed" }, close)
              picker.list.win:on("CursorMoved", function()
                show_overflow(picker)
              end)
              show_overflow(picker)
            end,
            on_change = function(picker)
              show_overflow(picker)
            end,
            actions = {
              explorer_open_chain = function(picker, item, action)
                local actions = require("snacks.explorer.actions")
                if not item or not item.dir or item.open or picker.input.filter.meta.searching then
                  return actions.actions.confirm(picker, item, action)
                end
                local tree = require("snacks.explorer.tree")
                local path = item.file
                -- Stop at branches, files, and symlinks; bound traversal depth.
                for _ = 1, 50 do
                  tree:open(path)
                  local node = tree:find(path)
                  tree:expand(node)
                  local children = vim.tbl_values(node.children or {})
                  if #children ~= 1 or not children[1].dir or children[1].type == "link" then
                    break
                  end
                  path = children[1].path
                end
                actions.update(picker, { refresh = true, target = path })
              end,
            },
            win = {
              list = {
                keys = {
                  ["<CR>"] = "explorer_open_chain",
                  ["l"] = "explorer_open_chain",
                },
              },
            },
          },
        },
      },
    },
  },
}
