_: {
  # Noctalia runtime-generates ~/.config/hypr/noctalia.conf with dynamic theme
  # colours and wallpaper paths. There is no structured Nix option for sourcing
  # an external file in Lua, so this is the sole use of extraLua.
  desktop.hyprland.extraLua = ''
    -- Noctalia dynamic theme (generated at runtime by the compositor shell)
    hl.source("~/.config/hypr/noctalia.conf")
  '';
}
