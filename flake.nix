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
      system = "aarch64-darwin";

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      users = import ./users.nix;

      darwinSystem =
        {
          updateHomebrew ? false,
          profile,
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit pkgs-unstable users;
            homeDirectory = users.${profile}.homeDirectory;
            username = users.${profile}.username;
            profile = users.${profile}.profile;
          };
          modules = [
            {
              nix.settings.experimental-features = "nix-command flakes";
              nixpkgs.hostPlatform = system;
              system = {
                configurationRevision = self.rev or self.dirtyRev or null;
                stateVersion = 6;
                primaryUser = users.${profile}.username;
              };
            }

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
                extraSpecialArgs = {
                  inherit pkgs-unstable;
                  profile = users.${profile}.profile;
                };
                users = import ./modules/home-manager { inherit users; };
              };
            }
          ];
        };

    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
      darwinConfigurations."personal" = darwinSystem {
        updateHomebrew = false;
        profile = "personal";
      };
      darwinConfigurations."personal-updatehomebrew" = darwinSystem {
        updateHomebrew = true;
        profile = "personal";
      };
      darwinConfigurations."work" = darwinSystem {
        updateHomebrew = false;
        profile = "work";
      };
      darwinConfigurations."work-updatehomebrew" = darwinSystem {
        updateHomebrew = true;
        profile = "work";
      };
    };
}
