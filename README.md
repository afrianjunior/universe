## Deployment

### Once, setup Server from local
``` shell
nix run github:nix-community/nixos-anywhere -- --build-on-remote --flake .#juun-nix-server root@ip
```

### Continue Integration

on local or build machine
``` shell
nix run nixpkgs#nixos-rebuild -- --flake .#juun-nix-server --fast --target-host "root@ip" --build-host "root@ip" --use-remote-sudo --fast switch
```

## Secrets

Aware to encrypt before commit

### Encript
``` shell
nix run nixpkgs#sops -- encrypt secrets/secret.yaml -i
```

### Decrypt
``` shell
nix run nixpkgs#sops -- decrypt -i secrets/secret.yaml
```

### Update keys if add new key on .sops.yaml
``` shell
nix run nixpkgs#sops -- updatekeys secrets/secret.yaml
```
