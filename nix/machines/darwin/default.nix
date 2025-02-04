{ inputs, ... }:

let 
    system = "aarch64-darwin";
    pkgs = import inputs.nixpkgs { 
      inherit system;
      config.allowUnfree = true;
    };
in
{
  flake.darwinConfigurations.afrianjunior = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    modules = [
      ./configuration.nix
      inputs.home-manager.darwinModules.home-manager
      {
        users.users.afrianjunior = {
          name = "afrianjunior";
          home = "/Users/afrianjunior";
        };

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.afrianjunior = import ./home.nix;
        };


      }
      # 
      #   { pkgs, ... }:
      #   {
      #     system.stateVersion = 5;
      #     services.nix-daemon.enable = true;
      #     security.pam.enableSudoTouchIdAuth = false;

      #     # keep on ventura
      #     ids.uids.nixbld = 300;

      #     environment.systemPackages = [
      #       pkgs.sops
      #       pkgs.openvpn
      #       pkgs.devenv
      #     ];

      #     programs.gnupg.agent.enable = true;
      #   }
      # )
    ];
    specialArgs = { inherit pkgs; };
  };
}

