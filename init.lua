local autoconf = require("autoconf")

autoconf.define_resolver("editor.theme", {
    resolver = function(name) return require("themekit").apply(name) end,
    lifecycle = autoconf.Lifecycle.LATE,
})
autoconf.define_command_resolver("open_theme_picker",
    function(_) return vim.cmd("ThemePicker") end)

local function open_workbench_view(view_id)
    local ok, workbench = pcall(require, "workbench")
    if not ok then
        vim.notify("Workbench runtime is not installed in this Neovim package", vim.log.levels.WARN)
        return nil
    end
    local view, err = workbench.open(view_id)
    if not view then
        vim.notify("Workbench " .. view_id .. " unavailable: " ..
            tostring(type(err) == "table" and err.message or err), vim.log.levels.WARN)
        return nil, err
    end
    return view
end

autoconf.define_command_resolver("workbench_files",
    {
        fn = function(_) return open_workbench_view("files") end,
        opts = { desc = "Workbench: open Files" },
    })
autoconf.define_command_resolver("workbench_search",
    {
        fn = function(_) return open_workbench_view("search") end,
        opts = { desc = "Workbench: open Search" },
    })
