{
  description = "Multi-user nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
    }:

    let
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      system = "aarch64-darwin";
      users = import ./users.nix;

      darwinSystem =
        {
          updateHomebrew,
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit pkgs-unstable updateHomebrew;
          };
          modules = [
            {
              # general settings
              nix.settings.experimental-features = "nix-command flakes";
              nixpkgs.hostPlatform = system;
              system = {
                configurationRevision = self.rev or self.dirtyRev or null;
                stateVersion = 6;
                # homebrew runs as the primary user, and /opt/homebrew is owned by jblik
                primaryUser = users.personal.username;
              };
            }

            ./modules

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                verbose = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit pkgs-unstable;
                };
                users = nixpkgs.lib.mergeAttrsList (
                  map (
                    user:
                    import ./modules/home-manager {
                      inherit user;
                      lib = nixpkgs.lib;
                    }
                  ) (builtins.attrValues users)
                );
              };
            }
          ];
        };

    in
    {
      # todo make a devshell with all the packages the flake has
      #    devShell = inputs.nixpkgs.legacyPackages.${system} {
      #              };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      darwinConfigurations."default" = darwinSystem {
        updateHomebrew = false;
      };
      darwinConfigurations."default-updatehomebrew" = darwinSystem {
        updateHomebrew = true;
      };
    };
}
