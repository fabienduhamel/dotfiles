return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_highlight_matches = "underline"
    end,
    config = function()
      local function set_vm_highlights()
        vim.api.nvim_set_hl(0, "VM_Cursor", { fg = "#1f2335", bg = "#ffd166", bold = true })
        vim.api.nvim_set_hl(0, "VM_Extend", { fg = "#1f2335", bg = "#7dcfff", bold = true })
        vim.api.nvim_set_hl(0, "VM_Insert", { fg = "#1f2335", bg = "#a6e3a1", bold = true })
        vim.api.nvim_set_hl(0, "MultiCursor", { link = "VM_Cursor" })
      end

      set_vm_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("user_vm_highlights", { clear = true }),
        callback = set_vm_highlights,
      })
    end,
  },
}
