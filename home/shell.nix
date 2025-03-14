{
  pkgs,
  vars,
  ...
}:
let
  mySessionVariables = {
    FLAKE = vars.flakePath;
    EDITOR = vars.defaults.termEditor;
    VISUAL = vars.defaults.editor;

    # dirac
    AWS_PROFILE = "dirac-dev";
  };
  myShellAliases = {
    cdn = "cd ${vars.flakePath}";

    zed = "zeditor";
    e = "${vars.defaults.editor} .";
    code = "zsh -c '(&>/dev/null cursor . &)'";

    lg = "lazygit";
    ld = "lazydocker";
    nhos = "nh os switch";
    nhob = "nh os boot";
    hmclean = "fd '${vars.hmBackupFileExtension}' ~ -u -x rm";

    # dirac
    cdb = "cd /home/drew/dirac/buildos-web";
    awsl = "zsh -c 'sudo rm -rf ~/.aws/cli ~/.aws/sso && aws sso login --profile ${mySessionVariables.AWS_PROFILE}'";
  };
  nushellCatppuccin = pkgs.fetchFromGitHub {
    owner = "nik-rev";
    repo = "catppuccin-nushell";
    rev = "82c31124b39294c722f5853cf94edc01ad5ddf34";
    hash = "sha256-O95OrdF9UA5xid1UlXzqrgZqw3fBpTChUDmyExmD2i4=";
  };
  nushellConfig =
    builtins.readFile "${nushellCatppuccin}/themes/catppuccin_mocha.nu"
    + ''
      $env.config.show_banner = false
      $env.config.buffer_editor = "nvim"
    '';
in
{
  home = {
    shellAliases = myShellAliases;
    sessionVariables = mySessionVariables;
  };
  programs = {
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      initExtra = ''
        function y() {
         	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
         	yazi "$@" --cwd-file="$tmp"
         	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          		builtin cd -- "$cwd"
         	fi
         	rm -f -- "$tmp"
        }
      '';
    };

    bash.enable = true;

    nushell = {
      enable = true;
      environmentVariables = mySessionVariables;
      shellAliases = myShellAliases;
      extraConfig = nushellConfig;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;

      config = {
        whitelist = {
          prefix = [
            "~/buildos-web"
            "~/dirac"
          ];
        };
      };
    };

    eza = {
      enable = true;
      icons = "auto";
      enableNushellIntegration = false;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      settings = {
        auto_sync = true;
        enter_accept = true;
        style = "compact";
        inline_height = 20;
        filter_mode_shell_up_key_binding = "session";
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = false;
      enableBashIntegration = false;
      enableFishIntegration = false;
    };

    starship = {
      enable = true;
      settings = {
        format = "$all$shell$character";
        aws = {
          disabled = true;
        };
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        # configure shell-specific icons
        shell = {
          disabled = false;
          format = "$indicator($style)";
          bash_indicator = "\\$ ";
          zsh_indicator = "";
          nu_indicator = "nu ";
          unknown_indicator = "? ";
          style = "white bold";
        };
      };
    };

    zellij = {
      enable = true;

      enableBashIntegration = false;
      enableZshIntegration = false;
      enableFishIntegration = false;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };
  };
}
