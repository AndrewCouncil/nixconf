{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    nvidiaEnable = lib.mkEnableOption {
      default = false;
      description = "NVIDIA GPU support";
    };
  };

  config = lib.mkIf config.nvidiaEnable {
    environment.systemPackages = with pkgs; [
      egl-wayland
      nvitop
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
        pulseaudio = true;
        nvidia.acceptLicense = true;
        # packageOverrides = pkgs: { inherit (pkgs) linuxPackages_latest nvidia_x11; };
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
