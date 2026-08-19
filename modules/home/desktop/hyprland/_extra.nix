{lib, ...}: let
  vars = import ./_lib.nix {inherit lib;};
  inherit (vars) terminal;
in {
  # Real Lua logic for the 3 features that can't be plain Nix: resize,
  # PiP, and the special-workspace launcher. See README.md.
  wayland.windowManager.hyprland.extraConfig = ''
    -- json.lua (c) 2020 rxi, MIT. https://github.com/rxi/json.lua
    -- needed by load_toggle_config() below to read cli.json
    local json = {}
    do
        local encode
        local escape_char_map = { ["\\"] = "\\", ["\""] = "\"", ["\b"] = "b", ["\f"] = "f", ["\n"] = "n", ["\r"] = "r", ["\t"] = "t" }
        local escape_char_map_inv = { ["/"] = "/" }
        for k, v in pairs(escape_char_map) do escape_char_map_inv[v] = k end
        local function decode_error(str, idx, msg)
            error(string.format("%s at position %d", msg, idx))
        end
        local function codepoint_to_utf8(n)
            local f = math.floor
            if n <= 0x7f then return string.char(n)
            elseif n <= 0x7ff then return string.char(f(n / 64) + 192, n % 64 + 128)
            elseif n <= 0xffff then return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
            elseif n <= 0x10ffff then return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128, f(n % 4096 / 64) + 128, n % 64 + 128) end
            error(string.format("invalid unicode codepoint '%x'", n))
        end
        local function parse_unicode_escape(s)
            local n1 = tonumber(s:sub(1, 4), 16)
            local n2 = tonumber(s:sub(7, 10), 16)
            if n2 then return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000) end
            return codepoint_to_utf8(n1)
        end
        local space_chars = { [" "] = true, ["\t"] = true, ["\r"] = true, ["\n"] = true }
        local delim_chars = { [" "] = true, ["\t"] = true, ["\r"] = true, ["\n"] = true, ["]"] = true, ["}"] = true, [","] = true }
        local escape_chars = { ["\\"] = true, ["/"] = true, ["\""] = true, ["b"] = true, ["f"] = true, ["n"] = true, ["r"] = true, ["t"] = true, ["u"] = true }
        local literals = { ["true"] = true, ["false"] = true, ["null"] = true }
        local literal_map = { ["true"] = true, ["false"] = false, ["null"] = nil }
        local function next_char(str, idx, set, negate)
            for i = idx, #str do
                if set[str:sub(i, i)] ~= negate then return i end
            end
            return #str + 1
        end
        local parse
        local function parse_string(str, i)
            local res, j, k = "", i + 1, i + 1
            while j <= #str do
                local x = str:byte(j)
                if x < 32 then
                    decode_error(str, j, "control character in string")
                elseif x == 92 then
                    res = res .. str:sub(k, j - 1)
                    j = j + 1
                    local c = str:sub(j, j)
                    if c == "u" then
                        local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1) or str:match("^%x%x%x%x", j + 1)
                            or decode_error(str, j - 1, "invalid unicode escape in string")
                        res = res .. parse_unicode_escape(hex)
                        j = j + #hex
                    else
                        if not escape_chars[c] then decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string") end
                        res = res .. escape_char_map_inv[c]
                    end
                    k = j + 1
                elseif x == 34 then
                    res = res .. str:sub(k, j - 1)
                    return res, j + 1
                end
                j = j + 1
            end
            decode_error(str, i, "expected closing quote for string")
        end
        local function parse_number(str, i)
            local x = next_char(str, i, delim_chars)
            local s = str:sub(i, x - 1)
            local n = tonumber(s)
            if not n then decode_error(str, i, "invalid number '" .. s .. "'") end
            return n, x
        end
        local function parse_literal(str, i)
            local x = next_char(str, i, delim_chars)
            local word = str:sub(i, x - 1)
            if not literals[word] then decode_error(str, i, "invalid literal '" .. word .. "'") end
            return literal_map[word], x
        end
        local function parse_array(str, i)
            local res, n = {}, 1
            i = i + 1
            while true do
                local x
                i = next_char(str, i, space_chars, true)
                if str:sub(i, i) == "]" then i = i + 1; break end
                x, i = parse(str, i)
                res[n] = x
                n = n + 1
                i = next_char(str, i, space_chars, true)
                local chr = str:sub(i, i)
                i = i + 1
                if chr == "]" then break end
                if chr ~= "," then decode_error(str, i, "expected ']' or ','") end
            end
            return res, i
        end
        local function parse_object(str, i)
            local res = {}
            i = i + 1
            while true do
                local key, val
                i = next_char(str, i, space_chars, true)
                if str:sub(i, i) == "}" then i = i + 1; break end
                if str:sub(i, i) ~= "\"" then decode_error(str, i, "expected string for key") end
                key, i = parse(str, i)
                i = next_char(str, i, space_chars, true)
                if str:sub(i, i) ~= ":" then decode_error(str, i, "expected ':' after key") end
                i = next_char(str, i + 1, space_chars, true)
                val, i = parse(str, i)
                res[key] = val
                i = next_char(str, i, space_chars, true)
                local chr = str:sub(i, i)
                i = i + 1
                if chr == "}" then break end
                if chr ~= "," then decode_error(str, i, "expected '}' or ','") end
            end
            return res, i
        end
        local char_func_map = {
            ["\""] = parse_string, ["0"] = parse_number, ["1"] = parse_number, ["2"] = parse_number,
            ["3"] = parse_number, ["4"] = parse_number, ["5"] = parse_number, ["6"] = parse_number,
            ["7"] = parse_number, ["8"] = parse_number, ["9"] = parse_number, ["-"] = parse_number,
            ["t"] = parse_literal, ["f"] = parse_literal, ["n"] = parse_literal,
            ["["] = parse_array, ["{"] = parse_object,
        }
        parse = function(str, idx)
            local chr = str:sub(idx, idx)
            local f = char_func_map[chr]
            if f then return f(str, idx) end
            decode_error(str, idx, "unexpected character '" .. chr .. "'")
        end
        function json.decode(str)
            local res, idx = parse(str, next_char(str, 1, space_chars, true))
            return res
        end
    end

    -- resize relative to the window's current size, not fixed pixels
    local function resize_active_window(x, y)
        return function()
            local win = hl.get_active_window()
            if win and win.size then
                local w = win.size.x * (x / 100)
                local h = win.size.y * (y / 100)
                hl.dispatch(hl.dsp.window.resize({ x = w, y = h, relative = true }))
            else
                hl.dispatch(hl.dsp.no_op())
            end
        end
    end

    local function resize_by_screen(x, y)
        local screen = hl.get_active_monitor()
        if screen and type(screen.width) == "number" and type(screen.height) == "number" then
            local w = (x and x > 0) and math.floor(screen.width * x / 100) or screen.width
            local h = (y and y > 0) and math.floor(screen.height * y / 100) or screen.height
            return { x = w, y = h, relative = false }
        end
    end

    -- corner placement, used both for manual PiP and auto-positioning
    local function move_actions(win)
        local screen = hl.get_active_monitor()
        if screen and screen.width and screen.height and win and win.size then
            local monitor_height = screen.height / screen.scale
            local monitor_width = screen.width / screen.scale
            local scale_factor = (monitor_height / 4) / win.size.y
            local target_width = win.size.x * scale_factor
            local target_height = win.size.y * scale_factor
            local x_resize = math.floor(math.max(200, target_width))
            local y_resize = math.floor(math.max(150, target_height))
            local offset = math.min(monitor_width, monitor_height) * 0.03
            local move_x = math.floor(screen.x + monitor_width - x_resize - offset)
            local move_y = math.floor(screen.y + monitor_height - y_resize - offset)
            return {
                hl.dsp.window.resize({ x = x_resize, y = y_resize, window = win }),
                hl.dsp.window.move({ x = move_x, y = move_y, relative = false, window = win }),
            }
        end
    end

    local function resizer(window, pattern, x_percent, y_percent, actions, exact, field)
        local value = window and window[field or "title"]
        if value and string.find(value, pattern, 1, exact) then
            local disp = (type(actions) == "table") and actions or { actions }
            for _, x in ipairs(disp) do
                hl.dispatch(x)
            end
            local sz = resize_by_screen(x_percent, y_percent)
            if sz then
                sz.window = window
                hl.dispatch(hl.dsp.window.resize(sz))
            end
            hl.dispatch(hl.dsp.window.set_prop({ prop = "keep_aspect_ratio", value = "true", window = window }))
        end
    end

    local function apply_resizer_rules(win)
        local float_center = {
            hl.dsp.window.float({ action = "on", window = win }),
            hl.dsp.window.center({ window = win }),
        }
        local pip_actions = move_actions(win) or {}
        resizer(win, "Bitwarden", 20, 54, float_center, true, "class")
        resizer(win, "^Extension: %(Bitwarden Password Manager%) %- Bitwarden", 20, 54, float_center, false)
        resizer(win, "Picture[- ][Ii]n[- ][Pp]icture", 0, 0, pip_actions, false)
    end

    hl.on("window.title", apply_resizer_rules)
    hl.on("window.open", apply_resizer_rules)

    hl.bind("SUPER + Minus", resize_active_window(-10, 0), { repeating = true })
    hl.bind("SUPER + Equal", resize_active_window(10, 0), { repeating = true })
    hl.bind("SUPER + SHIFT + Minus", resize_active_window(0, -10), { repeating = true })
    hl.bind("SUPER + SHIFT + Equal", resize_active_window(0, 10), { repeating = true })

    -- resize to 55%x70% of screen and center
    hl.bind("CTRL + SUPER + ALT + Backslash", function()
        hl.dispatch(hl.dsp.window.resize(resize_by_screen(55, 70)))
        hl.dispatch(hl.dsp.window.center())
    end)

    hl.bind("SUPER + ALT + Backslash", function()
        local a = hl.get_active_window()
        if a then
            local pip = move_actions(a) or {}
            if not a.floating then table.insert(pip, 1, hl.dsp.window.float()) end
            table.insert(pip, hl.dsp.window.pin({ action = "on", window = "address:" .. a.address }))
            for _, x in ipairs(pip) do
                hl.dispatch(x)
            end
        end
    end)

    -- toggle a hidden workspace, launching its app(s) if not already running
    local function default_toggle_config()
        return {
            communication = {
                discord = { enable = true, match = { { class = "discord" } }, command = { "discord" }, move = true },
                whatsapp = { enable = true, match = { { class = "whatsapp" } }, move = true },
            },
            music = {
                spotify = { enable = true, match = { { class = "Spotify" } }, command = { "spotify" }, move = true },
                feishin = { enable = true, match = { { class = "feishin" } }, move = true },
            },
            sysmon = {
                btop = { enable = true, match = { { class = "btop" } }, command = { "${terminal}", "-e", "btop" } },
            },
            todo = {
                todoist = { enable = true, match = { { class = "todoist" } }, command = { "todoist" }, move = true },
            },
        }
    end

    local function shell_join(argv)
        local quoted = {}
        for i, arg in ipairs(argv) do
            quoted[i] = "'" .. tostring(arg):gsub("'", [['"'"']]) .. "'"
        end
        return table.concat(quoted, " ")
    end

    local function get_field(obj, key)
        local value = obj[key]
        if value == nil and type(key) == "string" then
            value = obj[(key:gsub("(%u)", "_%1")):lower()]
        end
        return value
    end

    local function deep_match(actual, expected)
        if type(expected) == "table" then
            if type(actual) ~= "table" and type(actual) ~= "userdata" then return false end
            for key, sub_expected in pairs(expected) do
                if not deep_match(get_field(actual, key), sub_expected) then return false end
            end
            return true
        else
            return actual and string.find(tostring(actual), tostring(expected), 1, true)
        end
    end

    local function get_clients(clients, app_config, target_special)
        local matched_clients = {}
        if app_config and app_config.match then
            for _, window in ipairs(clients) do
                for _, rule in ipairs(app_config.match) do
                    local is_a_match = true
                    for key, expected_value in pairs(rule) do
                        if not deep_match(get_field(window, key), expected_value) then
                            is_a_match = false
                            break
                        end
                    end
                    if is_a_match then
                        local client_workspace = window.workspace and window.workspace.name
                        table.insert(matched_clients, {
                            window = window,
                            is_in_place = (client_workspace == "special:" .. target_special),
                        })
                        break
                    end
                end
            end
            return #matched_clients > 0, matched_clients
        end
        return false, matched_clients
    end

    local function load_toggle_config()
        local config = default_toggle_config()
        local home = os.getenv("HOME")
        local config_dir = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
        local user_file = io.open(config_dir .. "/caelestia/cli.json", "r")
        if not user_file then return config end
        local content = user_file:read("*a")
        user_file:close()
        local recognized, conf_or_error = pcall(json.decode, content)
        if recognized and type(conf_or_error) == "table" and conf_or_error.toggles then
            for category, apps in pairs(conf_or_error.toggles) do
                config[category] = config[category] or {}
                for app_name, options in pairs(apps) do
                    config[category][app_name] = config[category][app_name] or {}
                    for key, value in pairs(options) do
                        config[category][app_name][key] = value
                    end
                end
            end
        end
        return config
    end

    local function place_apps(apps, special_workspace)
        local target = "special:" .. special_workspace
        local clients = hl.get_windows() or {}
        for _, app in pairs(apps) do
            if app.enable then
                local is_running, target_clients = get_clients(clients, app, special_workspace)
                if not is_running then
                    if app.command then
                        hl.dispatch(hl.dsp.exec_cmd(shell_join(app.command), { workspace = target }))
                    end
                elseif app.move then
                    for _, target_client in ipairs(target_clients) do
                        if not target_client.is_in_place then
                            hl.dispatch(hl.dsp.window.move({ window = target_client.window, workspace = target, follow = false }))
                        end
                    end
                end
            end
        end
    end

    local function toggle(special_workspace)
        return function()
            local active_workspace = hl.get_active_special_workspace()
            if special_workspace == "specialws" then
                local target = active_workspace and active_workspace.name:gsub("^special:", "") or "special"
                return hl.dispatch(hl.dsp.workspace.toggle_special(target))
            end
            local on_correct_ws = active_workspace and active_workspace.name == "special:" .. special_workspace
            if not on_correct_ws then
                hl.dispatch(hl.dsp.focus({ workspace = "special:" .. special_workspace }))
            end
            local apps = load_toggle_config()[special_workspace]
            if apps then
                place_apps(apps, special_workspace)
            end
            if on_correct_ws then
                hl.dispatch(hl.dsp.workspace.toggle_special(special_workspace))
            end
        end
    end

    hl.bind("SUPER + S", toggle("specialws"))
    hl.bind("CTRL + SHIFT + Escape", toggle("sysmon"))
    hl.bind("SUPER + M", toggle("music"))
    hl.bind("SUPER + D", toggle("communication"))
    hl.bind("SUPER + R", toggle("todo"))

    -- 3-finger-down swipe = same as SUPER+S, needs toggle() so lives here
    hl.gesture({ fingers = 3, direction = "down", action = toggle("specialws") })
  '';
}
