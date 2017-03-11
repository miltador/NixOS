# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

with lib;

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader settings
  boot.loader = {
    systemd-boot.enable = true;  
    efi.canTouchEfiVariables = true;
  };
  # Swap
  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  # Networking
  networking = {
    hostName = "mini";
    networkmanager.enable = true;
  };

  # Localization
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Kiev";

  nixpkgs.config.allowUnfree = true;

  # Global packages
  environment.systemPackages = with pkgs; [
    git
    skype
    nix-repl
    libreoffice
    (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { enableGTK3 = true; }) {})
  ];

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Hardware settings
  hardware = {
    opengl.extraPackages = [ pkgs.vaapiIntel ];
    cpu.intel.updateMicrocode = true;
  };

  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
  };

  # Gnome Shell Desktop Environment settings
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  environment.gnome3.excludePackages = [
    pkgs.gnome3.accerciser
    pkgs.gnome3.gnome-packagekit
    pkgs.gnome3.gnome-software
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’
  users.extraUsers.miltador = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "wheel" "networkmanager" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases
  system = {
    stateVersion = "16.09";
    autoUpgrade.enable = true;
  };
}
