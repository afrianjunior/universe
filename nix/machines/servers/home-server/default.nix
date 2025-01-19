{ inputs, nixpkgs, home-manager, ... }:

{
  flake = {
    homeConfigurations.home-server = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch66-linux;

      modules = [
        ./modules/cli.nix
        {
          home = {
            username = "juunn";
            homeDirectory = "/home/pi";
            stateVersion = "23.11";
          };
          programs.home-manager.enable = true;
        }
      ];
    };
  };
}
