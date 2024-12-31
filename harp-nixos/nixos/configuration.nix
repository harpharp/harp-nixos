# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nix.settings.experimental-features = [ "nix-command" ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.kernelModules = [
    "iwlwifi"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  virtualisation.docker.enable = true;

  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = true;

  services.xserver = {
    enable = true;
    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [
        qtile-extras
      ];
    };
  };

  services.displayManager.sddm = {
    enable = true;
    settings = {
      Theme = {
        Current = "sugar-candy";
        ThemeDir = "/sddmt";
      };
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
#  environment.systemPackages = pkgs.linux-firmware;
#  environment.sessionVariables.TERMINAL = "kitty";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
#    LC_ADDRESS = "de_AT.UTF-8";
#    LC_IDENTIFICATION = "de_AT.UTF-8";
#    LC_MEASUREMENT = "de_AT.UTF-8";
#    LC_MONETARY = "de_AT.UTF-8";
#    LC_NAME = "de_AT.UTF-8";
#    LC_NUMERIC = "de_AT.UTF-8";
#    LC_PAPER = "de_AT.UTF-8";
#    LC_TELEPHONE = "de_AT.UTF-8";
#    LC_TIME = "de_AT.UTF-8";
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8"; 
    LC_TIME = "en_US.UTF-8";
  };

# Enable the KDE Plasma Desktop Environment.
#  services.displayManager.sddm.enable = true;
#  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = false;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
  };
  services.blueman.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  programs.fish.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.harp = {
    isNormalUser = true;
    description = "harp";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
    packages = with pkgs; [
#      kdePackages.kate
#      kdePackages.qtsvg
    #  thunderbird
    ];
    shell = pkgs.fish;
  };

  # Install firefox.
  # programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
#  programs.rofi = {
#    enable = true;
#    package = pkgs.rofi;
#    theme = ./themes/catppucin-mocha.rasi;
#  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    linux-firmware
    wirelesstools
    librewolf
    steam
    vesktop
    signal-desktop
    spotify
    git
    rofi
    rofi-power-menu
    rofi-screenshot
    kitty
#    dolphin
    kdePackages.qtsvg
    scrot
    xclip
    nitrogen
    neofetch
    bitwarden
#    papirus-icon-theme
    catppuccin-papirus-folders
#    playerctl
    pavucontrol
    pamixer
    bluez
    bluez-tools
#    gnome-power-manager
    alsa-utils
#    xorg.xbacklight
#    brightnessctl
#    xarchiver
    kdePackages.gwenview
    libsForQt5.qt5.qtgraphicaleffects
  ];

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  programs.file-roller.enable = true; # archive functionality

  fonts.packages = with pkgs; [ 
    open-sans
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # screen brightness control
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
    ];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;


#  environment.etc."picom.conf".text = builtins.readFile "/etc/nixos/picom.conf"; 

  services.picom.enable = true;
  services.upower.enable = true;
  services.suwayomi-server.enable = true;  

#  programs.rofi.enable = true; 
 # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
