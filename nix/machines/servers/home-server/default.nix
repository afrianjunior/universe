{ nixpkgs, home-manager, ... }:

let
  system = "aarch64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in {
  homeConfigurations = {
    "home-server" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      
      modules = [
        {
          imports = [
            ./modules/cli.nix
          ];

          home = {
            username = "juunn";
            homeDirectory = "/home/";
            stateVersion = "23.11";
          };

          programs.home-manager.enable = true;
        }
      ];
    };
    
  };
}

