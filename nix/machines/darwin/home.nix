{ config, pkgs, home-manager, ... }:

{
  imports = [
    ../../modules/shells.nix
  ];

  home.username = "afrianjunior";

  home.homeDirectory = "/Users/afrianjunior";

  # Packages to install
  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    neofetch
    zsh
  ];

  # Program-specific configurations
  programs.git = {
    enable = true;
    userName = "afrianjunior";
    userEmail = "afrian.junior26@gmail.com";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
