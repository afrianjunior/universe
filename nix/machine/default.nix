{ inputs, ... }:

{
  imports = [
    ./server.nix
  ];

  flake.darwinConfigurations.juun = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      (
        { pkgs, ... }:
        {
          system.stateVersion = 5;
          services.nix-daemon.enable = true;
          security.pam.enableSudoTouchIdAuth = false;

          # keep on ventura
          ids.uids.nixbld = 300;

          environment.systemPackages = [
            pkgs.sops
          ];

          programs.gnupg.agent.enable = true;
        }
      )
    ];

  };
}
