{
  lib,
  ezModules,
  osConfig,
  pkgs,
  inputs,
  ...
}:

{
  home = rec {
    username = "juunn";
    stateVersion = "24.11";
    homeDirectory = osConfig.users.users.${username}.home;
    packages = [inputs.ags.packages.${pkgs.system}.io];
  };

  imports = lib.attrValues ezModules;
}
