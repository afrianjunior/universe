{
  imports = [
    ./machine
    ./home
    ./pkgs
  ];

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
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };

        nodejs = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs
          ];
        };
      };
    };
}