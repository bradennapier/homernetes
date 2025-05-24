{
  description = "Homernetes NixOS configuration with k3s";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  outputs = { self, nixpkgs }: {
    nixosConfigurations.home = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          services.k3s.enable = true;
          services.k3s.extraFlags = "--disable traefik";
        })
      ];
    };
  };
}
