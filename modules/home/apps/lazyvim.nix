{inputs, ...}: {
  flake.modules.homeManager.lazyvim = {...}: {
    imports = [inputs.lazyvim.homeManagerModules.default];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs.lazyvim = {
      enable = true;
      ignoreBuildNotifications = true;

      extras = {
        lang = {
          nix.enable = true;
          json.enable = true;
          toml.enable = true;
          python = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
          typescript = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };
        ui = {
          mini-animate.enable = true;
          treesitter-context.enable = true;
          edgy.enable = true;
        };
        coding = {
          mini-surround.enable = true;
          yanky.enable = true;
        };
        editor = {
          mini-files.enable = true;
          navic.enable = true;
        };
      };

      plugins = {
        colorscheme = ''
          return {
            "LazyVim/LazyVim",
            opts = {
              colorscheme = "catppuccin",
            },
          }
        '';
        catppuccin = ''
          return {
            "catppuccin/nvim",
            name = "catppuccin",
            priority = 1000,
            opts = {
              flavour = "macchiato",
              transparent_background = true,
              integrations = {
                alpha = true,
                cmp = true,
                flash = true,
                gitsigns = true,
                illuminate = true,
                indent_blankline = { enabled = true },
                lsp_trouble = true,
                mason = true,
                mini = true,
                native_lsp = {
                  enabled = true,
                  underlines = {
                    errors = { "undercurl" },
                    hints = { "undercurl" },
                    warnings = { "undercurl" },
                    information = { "undercurl" },
                  },
                },
                navic = { enabled = true },
                neotree = true,
                noice = true,
                notify = true,
                semantic_tokens = true,
                telescope = true,
                treesitter = true,
                treesitter_context = true,
                which_key = true,
              },
            },
          }
        '';
      };
    };
  };
}
