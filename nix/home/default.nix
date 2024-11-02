{ self, ... }:
{
  flake.homeManager = {
    packages = import ./packages.nix;
    home-user-info =
      { lib, ... }:
      {
        options.home.user-info =
          (self.commonModules.users-primary { inherit lib; }).options.users.primaryUser;
      };
  };
}
