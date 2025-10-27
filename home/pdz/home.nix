{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pdz";
  home.homeDirectory = "/home/pdz";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Essentials
    ripgrep
    unzip
    gcc

    # Languages & Runtimes
    bun
    python314
    rustup

    # Editors
    neovim
    helix
    # neovim # will be managed using bob at some point

    # CLI Tools
    lazydocker
    lsd
    fzf
    bat
  ];

  home.file = {
    ".scripts/fcd.sh".source = ./files/fcd.sh;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  dconf.settings = {
    # enable minimize and maximize buttons
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };
    "org/gnome/desktop/input-sources" = {
      show-all-sources = true;
      sources = [ (lib.hm.gvariant.mkTuple[ "xkb" "eu" ]) ];
      xkb-options = [ "caps:escape" ];
    };
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      
      history = {
        size = 10000000;
        save = 10000000;
        ignoreSpace = true;
        ignoreDups = true;
        ignoreAllDups = true;
        expireDuplicatesFirst = true;
        extended = true;
        share = true;
        path = "${config.home.homeDirectory}/.zsh_history";
      };

      initContent = ''
        source <(fzf --zsh)
        source ~/.scripts/fcd.sh

        export CARGO_PATH=$HOME/.cargo/bin

        export PATH=$PATH:$CARGO_PATH

        bindkey -s '^@' 'fcd^M'
      '';

      shellAliases = {
        l = "lsd --all --human-readable --icon auto --icon-theme fancy --long";
        ls = "lsd";
        update = "sudo nixos-rebuild switch";
      };
    };

    git = {
      enable = true;
      userName = "px-d";
      userEmail = "philip@dziubinsky.de";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };

    starship = {
      enable = true;
      settings = {
        format = "pdz@devcube - $directory\$git_branch\$python\$line_break$character";
        directory = {
          truncation_length = 5;
          truncate_to_repo = true;
        };
        git_status = {
          disabled = true;
        };
        python = {
          format = "[$symbol$version( \\($virtual_env\\))]($style) ";
        };
      };
    };
  };
}
