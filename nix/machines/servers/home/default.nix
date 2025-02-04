{ inputs, ... }:

{
  flake.homeConfigurations.home-server = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;

      modules = [
        ./modules
        {
          home = {
            username = "juunn";
            homeDirectory = "/home/juunn";
            stateVersion = "23.11";
          };
          programs.home-manager.enable = true;

          virtualisation.docker = {
            enable = true;
            package = inputs.nixpkgs.docker;
          };
        }
      ];
  };
}
