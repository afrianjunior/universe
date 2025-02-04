{ inputs, pkgs, ... }:

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
            daemon.settings = {
              # Configure Docker to use overlay2 storage driver
              storage-driver = "overlay2";
              
              # Define default address pools for networks
              default-address-pools = [
                {
                  base = "172.16.0.0/16";
                  size = 24;
                }
                {
                  base = "172.17.0.0/16";
                  size = 24;
                }
              ];
              
              # Enable live restore
              live-restore = true;
              
              # Enable experimental features
              experimental = false;
            };
          };

          systemd.user.services.docker-socket = {
            Unit = {
              Description = "Docker Socket";
              Requires = ["docker.service"];
              After = ["docker.service"];
            };
            Service = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/chmod 666 /var/run/docker.sock";
            };
            Install = {
              WantedBy = ["default.target"];
            };
          };
        }
      ];
  };
}
