{
  description = "Multi-user nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
          profile,
          updateHomebrew,
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit pkgs-unstable updateHomebrew users;
            user = users.${profile};
          };
          modules = [
            {
              # general settings
              nix.settings.experimental-features = "nix-command flakes";
              nixpkgs.hostPlatform = system;
              system = {
                configurationRevision = self.rev or self.dirtyRev or null;
                stateVersion = 6;
                primaryUser = users.${profile}.username;
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
                  inherit nixpkgs;
                  user = users.${profile};
                };
                users = builtins.listToAttrs (
                  map (user: {
                    name = user.username;
                    value = import ./modules/home-manager { inherit user; pkgs = nixpkgs; };
                  }) (builtins.attrValues users)
                );
              };
            }
          ];
        };

    in
    {
      # todo make a devshell with all the packages the flake has
      #    devShell = inputs.nixpkgs.legacyPackages.${system} {
      #                mkShell import ./modules/apps/nixpackages.nix
      #              };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      darwinConfigurations."personal" = darwinSystem {
        profile = "personal";
        updateHomebrew = false;
      };
      darwinConfigurations."personal-updatehomebrew" = darwinSystem {
        profile = "personal";
        updateHomebrew = true;
      };
      darwinConfigurations."work" = darwinSystem {
        profile = "work";
        updateHomebrew = false;
      };
      darwinConfigurations."work-updatehomebrew" = darwinSystem {
        profile = "work";
        updateHomebrew = true;
      };
    };
}
