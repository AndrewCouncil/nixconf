{
  pkgs,
  vars,
  ...
}:

{
  # Enable zsh and make default
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # terminal tools
    neovim
    wget
    git
    git-lfs
    ripgrep
    fd
    bat
    eza
    yazi
    unzip
    btop
    htop
    hwinfo
    lshw
    gh
    lazygit
    lazydocker
    cht-sh
    nerdfetch
    ffmpeg
    imagemagick
    zstd
    nmap
    traceroute
    rclone
    lsof

    # language tools
    go
    gopls
    nil
    nixd
    markdown-oxide
    shellcheck

    # nix tools
    nix-output-monitor
    nixfmt-rfc-style
    nurl
    manix
    nix-search-cli
  ];

  # https://github.com/viperML/nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d";
    flake = vars.flakePath;
  };

  # Set up docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };

    # daemon.settings = {
    #   "bridge" = "none";
    # };
  };

  programs._1password.enable = true;
}
