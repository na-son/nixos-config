local active_cwd = ya.sync(function()
    return tostring(cx.active.current.cwd)
end)

return {
    entry = function()
        local cwd = active_cwd()
        local output = Command("git"):arg("status"):cwd(cwd):stderr(Command.PIPED):output()
        if not output or output.stderr ~= "" then
            ya.notify({
                title = "lazygit",
                content = "Not in a git directory: " .. cwd .. "\nError: " .. (output and output.stderr or "git status failed"),
                level = "warn",
                timeout = 5,
            })
        else
            local permit = ui.hide and ui.hide() or ya.hide()
            local output, err_code = Command("lazygit"):cwd(cwd):stdin(Command.INHERIT):stdout(Command.INHERIT):stderr(Command.PIPED):spawn()
            if output and not err_code then
                output, err_code = output:wait_with_output()
            end
            if err_code ~= nil then
                ya.notify({
                    title = "Failed to run lazygit command",
                    content = "Status: " .. err_code,
                    level = "error",
                    timeout = 5,
                })
            elseif not output.status.success then
                ya.notify({
                    title = "lazygit in " .. cwd .. " failed, exit code " .. output.status.code,
                    content = output.stderr,
                    level = "error",
                    timeout = 5,
                })
            end
        end
    end,
}
