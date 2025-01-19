{ nixpkgs, home-manager, ... }:

{
  flake.homeConfigurations.home-server = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;

      modules = [
        {
          home = {
            username = "juunn";
            homeDirectory = "/home/juunn";
            stateVersion = "23.11";
          };
          programs.home-manager.enable = true;
        }
      ];
  };
}
