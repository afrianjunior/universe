# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  ezModules,
  pkgs,
  inputs,
  config,
  hypr-darkwindow,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  imports = [
    # Include the results of the hardware scan.
    ezModules.juunnx-hardware
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_UsePageAttributeTable=1"
  ];

  home-manager.users.juunn = {
    wayland.windowManager.hyprland.plugins = [
      hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
    ];
  };

  environment.shells = with pkgs; [ zsh ];

  # Docker
  virtualisation.docker.enable = true;

  networking.hostName = "juunnx"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # ENvisronments
  environment.variables = {
    XDG_CONFIG_HOME = "/home/juunn/.config";
    WLR_RENDERER = "vulkan";
    __GL_GSYNC_ALLOWED = 0;
    __GL_VRR_ALLOWED = 0;
  };

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Bluetooth
  services.blueman.enable = true;

  # Enable the Hyperland Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  # services.xserver.desktopManager.gnome.enable = true;
  programs.hyprland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.juunn = {
    isNormalUser = true;
    description = "juunn";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      #  thunderbird
      zsh
      kitty
      warp-terminal
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # Install firefox.
  programs.firefox = {
    enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # XDG
  xdg.portal.enable = true;
  xdg.icons.enable = true;
  xdg.menus.enable = true;
  xdg.sounds.enable = true;

  # Waybar conf
  programs.waybar = {
    enable = true;
  };

  # systemd.services.hypr-discord-presence = {
  #   description = "Hyprland Discord Presence Daemon";
  #   after = [ "network.target" "graphical-session.target" ];
  #   wantedBy = [ "default.target" ];
  #   serviceConfig = {
  #     ExecStart = "/usr/bin/hypr-discord-presence --use-stream-window";
  #     Restart = "always";
  #     RestartSec = 3;
  #     User = "juunn";
  #     Environment = [
  #       "XDG_RUNTIME_DIR=/run/user/1000"
  #       "DISPLAY=:0"
  #       "WAYLAND_DISPLAY=wayland-1"
  #     ];
  #   };
  # };

  # systemd.user.services.wl-clip-persist = {
  #   enable = true;
  #   description = "clipboard sync persist";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist -d";
  #     Restart = "always";
  #   };
  #   wantedBy = [ "default.target" ];
  # };

  # services.vsftpd = {
  #   enable = true;
  #   writeEnable = true;
  #   extraConfig = ''
  #     pasv_enable=Yes
  #     pasv_min_port=51000
  #     pasv_max_port=56260
  #   '';
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 21 ];
  # networking.firewall.connectionTrackingModules = ["ftp"];
  # networking.firewall.allowedTCPPortRanges = [{ from= 51000; to = 56260; }];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    zsh
    lunarvim
    dunst
    kitty
    neofetch
    gitMinimal
    hyprpicker
    hyprpaper
    hyprshot
    hyprcursor
    hyprwayland-scanner
    catppuccin-cursors.mochaMauve
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    vsftpd
    file
    yazi
    imagemagick
    fd
    fzf
    zoxide
    ghostty
    wofi
    copyq
    waybar
    cliphist
    wayclip
    wl-clipboard
    wl-clip-persist
    networkmanagerapplet
    clipman
    direnv
    insomnia
    docker
    btop
    cointop
    chromium
    kubectx
    kubectl
    k9s
    nix-search
    mpd-discord-rpc
    zapzap
    unzip

    libreoffice-qt

    nodePackages.typescript-language-server
    nodePackages.typescript
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })
    claude-code
    code-cursor
    # epci games launcher
    legendary-gl

    # WINE
    # support both 32-bit and 64-bit applications
    wineWowPackages.stable

    # support 32-bit only
    wine

    # support 64-bit only
    (wine.override { wineBuild = "wine64"; })

    # support 64-bit only
    wine64

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    wineWowPackages.waylandFull
    # go
    go
    gcc
    gofumpt
    goimports-reviser
    golines
    gopls
    golangci-lint
    nixd
    pyright
    typescript
    typescript-language-server
    eslint
    pgsync
    cmake
    meson
    marksman
    cpio
    pkg-config
    beekeeper-studio
    heroic
    zed-editor
    windsurf
    zoom-us
    redisinsight
    teams-for-linux
    warp-terminal
    s-tui
    gparted
    inputs.astal.packages.${pkgs.stdenv.system}.default
    inputs.astal.packages.${pkgs.stdenv.system}.hyprland
    inputs.astal.packages.${pkgs.stdenv.system}.io
    inputs.astal.packages.${pkgs.stdenv.system}.astal3
    inputs.ags.packages.${pkgs.stdenv.system}.default
    inputs.ags.packages.${pkgs.stdenv.system}.hyprland

    inputs.self.packages.${pkgs.system}.nixvim
    inputs.zen-browser.packages.${pkgs.system}.default
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.1.5"
  ];
}
