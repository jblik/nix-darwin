{
  description = "My nix-darwin system flake";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-argoproj = {
      url = "github:argoproj/homebrew-tap";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nixpkgs-unstable,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      homebrew-argoproj,
      home-manager,
    }:

    let
      system = "aarch64-darwin";
      username = "jsteenblik";
      homeDirectory = "/Users/${username}";

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      configuration =
        { pkgs, ... }:
        {
          nix.settings.experimental-features = "nix-command flakes";

          system = {
            configurationRevision = self.rev or self.dirtyRev or null;
            # $ darwin-rebuild changelog
            stateVersion = 6;
            primaryUser = username;
          };

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = system;
        };

      myDarwinConfiguration =
        {
          updateHomebrew ? false,
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit pkgs-unstable username homeDirectory;
          };
          modules = [
            configuration
            ./modules
            {
              updateHomebrew.enable = updateHomebrew;
            }
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                verbose = true;
                backupFileExtension = "backup";
              };

              home-manager.users.${username} =
                { pkgs, lib, ... }:
                {
                  programs.home-manager.enable = true;
                  home.stateVersion = "25.11";
                  home.username = username;
                  home.homeDirectory = lib.mkForce homeDirectory;
                  imports = [
                    ./modules/home-manager
                  ];
                };
            }
            inputs.nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = username;
                taps = {
                  "homebrew/homebrew-core" = inputs.homebrew-core;
                  "homebrew/homebrew-cask" = inputs.homebrew-cask;
                  "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                  "argoproj/homebrew-tap" = inputs.homebrew-argoproj;
                };
                autoMigrate = true;
                mutableTaps = true;
              };
            }
          ];
        };

    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
      darwinConfigurations.${username} = myDarwinConfiguration { updateHomebrew = false; };
      darwinConfigurations."${username}-updatehomebrew" = myDarwinConfiguration {
        updateHomebrew = true;
      };
    };
}
