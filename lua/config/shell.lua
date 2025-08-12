local M = {}

function M.setup()
  local is_windows = vim.loop.os_uname().version:match("Windows")

  if is_windows then
    local shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
    if not vim.fn.executable(shell) then
      vim.notify("Neither pwsh nor powershell found. Using default shell.", vim.log.levels.WARN)
    end
    vim.opt.shell = shell
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command " ..
      "[Console]::InputEncoding=[Console]::OutputEncoding=" ..
      "[System.Text.Encoding]::UTF8;"
    vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
    vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
  else
    local zsh_path = vim.fn.exepath("zsh")
    vim.opt.shell = zsh_path ~= "" and zsh_path or vim.fn.exepath("bash")
    vim.opt.shellcmdflag = "-c"
    vim.opt.shellredir = ">%s 2>&1"
    vim.opt.shellpipe = "2>&1 | tee %s"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
  end
  vim.notify("Shell set to: " .. vim.opt.shell:get(), vim.log.levels.INFO)
end

return M
