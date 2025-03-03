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
  };

  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      pre-commit.settings.hooks = {
        deadnix.enable = true;
        nixfmt-rfc-style.enable = true;
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
