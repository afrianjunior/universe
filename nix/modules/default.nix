{ ... }:
{
  flake.commonModules = {
    user-primary = import ./user.nix;
  };
}
