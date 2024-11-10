{ inputs, ... }:

{
  flake.nixosConfigurations.juun-nix-server = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.disko.nixosModules.disko
      (
        {
          modulesPath,
          pkgs,
          ...
        }: 
        { 
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            (modulesPath + "/profiles/qemu-guest.nix")
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

          boot.loader.grub = {
            efiSupport = true;
            efiInstallAsRemovable = true;
          };

          services.openssh.enable = true;
          services.traefik.enable = true;
          services.traefik.staticConfigFile = pkgs.writeTextFile {
            name = "static_config.toml";
            text = # toml
              ''
                [entryPoints]
                  [entryPoints.web]
                    address = ":80"
                  [entryPoints.websecure]
                    address = ":443"

                [api]
                  dashboard = true

                [certificatesResolvers.letsencrypt.acme]
                  email = "hi@juun.dev"
                  storage = "acme.json"
                  [certificatesResolvers.letsencrypt.acme.httpChallenge]
                    entryPoint = "web"
              '';
          };

          nixpkgs.overlays = [
            (_:prev: {
              mongodb = with prev; stdenv.mkDerivation {
                name = "mongodb";
                pname = "mongodb";

                src = fetchurl {
                  # https://www.mongodb.com/try/download/community-edition/releases
                  url = "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-7.0.14.tgz";
                  hash = "sha256-tM+MquEIeFE17Mi4atjtbfXW77hLm5WlDsui/CRs4IQ=";
                };

                dontBuild = true;
                dontConfigure = true;

                nativeBuildInputs = [
                  autoPatchelfHook
                ];

                buildInputs =
                  [
                    stdenv.cc.cc.libgcc
                    curl
                    openssl
                  ];

                installPhase = ''
                  runHook preInstall

                  mkdir -p $out/bin
                  cp bin/mongod $out/bin/

                  runHook postInstall
                '';
              }
            ;
            })
          ];

          services.mongodb = {
            enable = true;
            package = pkgs.mongodb; 
            # Oddly the auth/initialRootPassword didn't work
            pidFile = "/run/mongodb/mongodb.pid";
            extraConfig = ''
              net:
                unixDomainSocket:
                  enabled: true
                  filePermissions: 0777
                  pathPrefix: "/run/mongodb"

              security.authorization: enabled
              setParameter:
                authenticationMechanisms: SCRAM-SHA-256
            '';
          };
          systemd.services.mongodb.serviceConfig = {
            RuntimeDirectory = "mongodb";

            # https://www.mongodb.com/docs/manual/reference/ulimit
            LimitFSIZE = "infinity";
            LimitCPU = "infinity";
            LimitAS = "infinity";
            LimitMEMLOCK = "infinity";
            LimitNOFILE = 64000;
            LimitNPROC = 64000;
          };

          nixpkgs.config.allowUnfree = true;

          environment.systemPackages = [
            pkgs.curl
            pkgs.gitMinimal
            pkgs.neofetch
            pkgs.lunarvim
          ];

          networking.firewall = {
            enable = true;
            allowedTCPPorts = [
              80
              443
              22
            ];
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
