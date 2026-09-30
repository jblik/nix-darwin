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
    darwinConfigurations.jsteenblik = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit username;
      };
      modules = [ 
          configuration
          ./modules/default.nix
          inputs.nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = username;
              taps = {
                "homebrew/homebrew-core"   = inputs.homebrew-core;
                "homebrew/homebrew-cask"   = inputs.homebrew-cask;
                "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                "argoproj/homebrew-tap"    = inputs.homebrew-argoproj;
              };
              autoMigrate = true;
              mutableTaps = true;
            };
          }
          # todo get started with home-manager:
          # home-manager.darwinModules.home-manager {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.verbose = true;

          #   home-manager.users.${userVars.userA.username} = { pkgs, lib, ... }:
          #   {
          #     home.stateVersion = "24.05";
          #     home.homeDirectory = lib.mkForce (userVars.userA.homeDirectory);
          #     programs.zsh.enable  = (userVars.userA.shell == "zsh");
          #     programs.fish.enable = (userVars.userA.shell == "fish");
          #     imports = [
          #       ./modules/home/${userVars.userA.username}/default.nix
          #     ];
          #   };
          # }
      ];
    };
  };
}

