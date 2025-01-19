{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ufw;
in
{
  options.services.ufw = {
    enable = mkEnableOption "Enable the Uncomplicated Firewall (UFW)";
    allowedTCPPorts = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of TCP ports to allow through the firewall.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.ufw
    ];
    networking.firewall.enable = false;

    services.ufw.allowedTCPPorts = [ "22" "80" "443" "5432" ]; # Add more ports as needed

    systemd.services.ufw = {
      description = "Uncomplicated Firewall";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.ufw}/bin/ufw --force enable";
        ExecStop = "${pkgs.ufw}/bin/ufw --force disable";
        ExecReload = "${pkgs.ufw}/bin/ufw --force reload";
      };
    };

    systemd.services.ufw-allow-ports = {
      description = "Open ports in Uncomplicated Firewall";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "ufw.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = concatMapStrings (port: "${pkgs.ufw}/bin/ufw allow ${port}\n") cfg.allowedTCPPorts;
      };
    };
  };
}
