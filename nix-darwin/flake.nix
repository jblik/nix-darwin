{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  # todo can delete this whole block as it'll come from the modules
  let 
  username = "jsteenblik";

  configuration = { pkgs, ... }: {
    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Enable alternative shell support in nix-darwin.
    # programs.fish.enable = true;

    # Set Git commit hash for darwin-version.
    system.configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 6;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#jsteenblik
    darwinConfigurations."jsteenblik" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit username;
      };
      modules = [ 
          configuration
          ./modules/default.nix
      ];
    };
  };
}

