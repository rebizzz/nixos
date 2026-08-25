_: {
  # pre-declared so noctalia's apply.sh doesn't try to append into this
  # read-only Home Manager file
  wayland.windowManager.hyprland.extraConfig = ''
    require("noctalia").apply_theme()

    -- layout(...) messages are scrolling-only and error on other layouts;
    -- hl_currentLayout is kept in sync by the SUPER+Tab layout-cycle bind.
    hl_currentLayout = "scrolling"

    function hl_layoutmsg(msg)
        if hl_currentLayout == "scrolling" then
            hl.dispatch(hl.dsp.layout(msg))
        end
    end

    function hl_focus(dir)
        if hl_currentLayout == "dwindle" then
            hl.dispatch(hl.dsp.focus({direction = dir}))
        else
            hl.dispatch(hl.dsp.layout("focus " .. dir))
        end
    end

    function hl_swapcol(dir)
        if hl_currentLayout == "dwindle" then
            hl.dispatch(hl.dsp.window.swap({direction = dir}))
        else
            hl.dispatch(hl.dsp.layout("swapcol " .. dir))
        end
    end
  '';
}
