-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")

local markdown = vim.api.nvim_create_augroup("user_markdown", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = markdown,
  pattern = "markdown",
  callback = function(event)
    vim.wo.spell = false
    vim.diagnostic.enable(false, { bufnr = event.buf })
  end,
})

for _, win in ipairs(vim.api.nvim_list_wins()) do
  local buf = vim.api.nvim_win_get_buf(win)
  if vim.bo[buf].filetype == "markdown" then
    vim.wo[win].spell = false
    vim.diagnostic.enable(false, { bufnr = buf })
  end
end

local autosave = vim.api.nvim_create_augroup("user_autosave", { clear = true })

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  group = autosave,
  callback = function(event)
    local buf = event.buf
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    if vim.bo[buf].buftype ~= "" then
      return
    end
    if not vim.bo[buf].modifiable or vim.bo[buf].readonly then
      return
    end
    if vim.bo[buf].modified and vim.api.nvim_buf_get_name(buf) ~= "" then
      pcall(vim.api.nvim_buf_call, buf, function()
        vim.cmd("silent update")
      end)
    end
  end,
})
