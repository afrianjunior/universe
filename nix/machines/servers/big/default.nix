{ inputs, ... }:

{
  flake.nixosConfigurations.big-server = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.disko.nixosModules.disko
      (
        {
          modulesPath,
          pkgs,
          config,
          self,
          ...
        }:
        {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            (modulesPath + "/profiles/qemu-guest.nix")
            inputs.sops.nixosModules.sops
            (
              { lib, ... }:
              {
                disko.devices = {
                  disk.disk1 = {
                    device = lib.mkDefault "/dev/sda";
                    type = "disk";
                    content = {
                      type = "gpt";
                      partitions = {
                        boot = {
                          name = "boot";
                          size = "1M";
                          type = "EF02";
                        };
                        esp = {
                          name = "ESP";
                          size = "500M";
                          type = "EF00";
                          content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                          };
                        };
                        root = {
                          name = "root";
                          size = "100%";
                          content = {
                            type = "lvm_pv";
                            vg = "pool";
                          };
                        };
                      };
                    };
                  };
                  lvm_vg = {
                    pool = {
                      type = "lvm_vg";
                      lvs = {
                        root = {
                          size = "100%FREE";
                          content = {
                            type = "filesystem";
                            format = "ext4";
                            mountpoint = "/";
                          };
                        };
                      };
                    };
                  };
                };
              }
            )
          ];

          # sops = {
          #   defaultSopsFile = ./secret.yaml;
          #   age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          #   secrets = {
          #     mongodb_root_password =
          #       {
          #       };
          #   };
          # };


          services.openssh.enable = true;


          environment.systemPackages = with pkgs; [
            curl
            gitMinimal
            neofetch
            lunarvim
            sops
            age
            ssh-to-age
            docker
            docker-compose
          ];

          networking.firewall = {
            enable = true;
            allowedTCPPorts = [ 80 22 443 27017 ];
          };

          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPuRdraxCF/KlEB06sUavOazZ/rg2DjhRVCpDxNmMHuY afrianjunior@afrians-MacBook-Pro-2.local"
          ];

          security.pam.sshAgentAuth.enable = true;
          system.stateVersion = "23.11";
        }
      )
    ];
  };
}
