{ config, pkgs, ... }:

{
  ids.uids.nixbld = 300;
  programs.gnupg.agent.enable = true;


  # System-wide settings
  system.defaults.dock.autohide = true;
  system.defaults.finder.AppleShowAllExtensions = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    gitMinimal
  ];

}
