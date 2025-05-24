# Nix Setup

This flake builds a NixOS configuration with k3s enabled. It disables the default Traefik ingress because our manifests install ingress separately. To build the image:

```bash
nix build .#nixosConfigurations.home.config.system.build.isoImage
```

Then flash the resulting ISO to disk and boot.
