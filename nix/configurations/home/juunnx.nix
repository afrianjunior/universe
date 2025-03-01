{
  lib,
  ezModules,
  osConfig,
  ...
}:

{
  home = rec {
    username = "juunnx";
    stateVersion = "24.11";
    homeDirectory = osConfig.users.users.${username}.home;
  };

  imports = lib.attrValues ezModules;
}
