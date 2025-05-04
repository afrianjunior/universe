{ inputs, ... }:
{
  imports = [
    inputs.ez-configs.flakeModule
    ./machines
  ];

  ezConfigs = {
    root = ./.;
    home.modulesDirectory = ./modules/home;
    home.configurationsDirectory = ./configurations/home;

    nixos.modulesDirectory = ./modules/nixos;
    nixos.configurationsDirectory = ./configurations/nixos;

    nixos.hosts = {
      juunnx.userHomeModules = ["juunn"];
    };

    globalArgs = {
      inherit inputs;
    };
  };

  perSystem =
    {
      pkgs,
      config,
      system,
      ...
    }:
    {
      pre-commit.settings.hooks = {
        deadnix.enable = true;
        nixfmt-rfc-style.enable = true;
      };

      packages = {
        # Define nixvim build using your own config folder
        nixvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
          inherit system;
          module = import ./nixvim/config; # path to your config like elythh
          extraSpecialArgs = { inherit inputs; };
        };
      };

      devShells = {
        default = pkgs.mkShell {
          # shellHook = ''
          #   ${config.pre-commit.installationScript}
          # '';
        };

        nodejs = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs
          ];
        };
      };
    };
}
