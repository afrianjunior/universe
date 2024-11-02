## Once, setup Server from local
``` shell
nix run github:nix-community/nixos-anywhere -- --build-on-remote --flake .#juun-nix-server root@ip
```

## Continue Integration

on local or build machine
``` shell
nix run nixpkgs#nixos-rebuild -- --flake .#juun-nix-server --fast --target-host "root@ip" --build-host "root@ip" --use-remote-sudo switch
```
