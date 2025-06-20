{
  pkgs,
  inputs,
  vars,
  ...
}:

{
  imports = [
    ./flatpak.nix
    ./fonts.nix
    ./kwallet.nix
    ./pwa.nix
  ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    mesa-demos

    kdePackages.dolphin
    lxqt.pcmanfm-qt

    thunderbird
    libreoffice-qt6-fresh
    kdePackages.okular
    system-config-printer

    inputs.zen-browser.packages.${pkgs.system}.default
    # firefox in home manager

    signal-desktop
    # discord
    vesktop

    qalculate-qt

    slack
    github-desktop
    postman
    # zoom-us

    pcloud
    localsend
    wireshark
    transmission_4-qt
    mullvad-vpn

    gparted

    audacity
    gimp
    inkscape
    feh
    upscayl
    xournalpp
    kdePackages.kdenlive

    vlc
    mpv
    spotify
    jellyfin-media-player
    calibre
    handbrake

    code-cursor
    zed-editor
    meld

    warp-terminal
    alacritty
    ghostty
    kitty

    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.qt6ct
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.plasma-workspace
    kdePackages.kconfig
  ];

  # fix dolphin default programs
  # https://discourse.nixos.org/t/dolphin-does-not-have-mime-associations/48985/8
  environment.etc."/xdg/menus/applications.menu".text =
    builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  programs = {
    _1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = [ vars.user ];
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    virt-manager.enable = true;

    weylus = {
      enable = true;
      openFirewall = true;
      users = [ vars.user ];
    };
  };

  # Set up virt manager
  users.groups.libvirtd.members = [ vars.user ];
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        .zen-wrapped
      '';
      mode = "0755";
    };
  };

  catppuccin.enable = true;

  services.desktopManager.plasma6.enableQt5Integration = true;
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };
}
