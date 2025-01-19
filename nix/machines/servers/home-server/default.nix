{ inputs, pkgs, ... }:

{
  flake.nixosConfigurations.home-server = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      inputs.sops.nixosModules.sops
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
    ];

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 22 443 ];
    };

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPuRdraxCF/KlEB06sUavOazZ/rg2DjhRVCpDxNmMHuY afrianjunior@afrians-MacBook-Pro-2.local"
    ];

    security.pam.sshAgentAuth.enable = true;
  };
}

