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

      users = import ./users.nix; # todo: could extend with different things such as git email etc

      # todo this is the base configuration and should be moved
      baseConfiguration =
        { ... }:
        {
          nix.settings.experimental-features = "nix-command flakes";
          nixpkgs.hostPlatform = system;
          system = {
            configurationRevision = self.rev or self.dirtyRev or null;
            stateVersion = 6;
            primaryUser = users.work.username;
          };
        };

      darwinSystemPersonal =
        {
          updateHomebrew ? false,
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit pkgs-unstable users;
          };
          modules = [
            baseConfiguration

            ./modules
            { updateHomebrew.enable = updateHomebrew;profile = "personal"; }
            
            ./modules/personal

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                verbose = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit pkgs-unstable; };
                users = import ./modules/home-manager { inherit users; };
              };
            }
          ];
        };
        
              darwinSystemWork =
                {
                  updateHomebrew ? false,
                }:
                nix-darwin.lib.darwinSystem {
                  specialArgs = {
                    inherit pkgs-unstable users;
                  };
                  modules = [
                    baseConfiguration
        
                    ./modules
                    { updateHomebrew.enable = updateHomebrew; profile = "work"; }
                    
                    ./modules/work
        
                    home-manager.darwinModules.home-manager
                    {
                      home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        verbose = true;
                        backupFileExtension = "backup";
                        extraSpecialArgs = { inherit pkgs-unstable; };
                        users = import ./modules/home-manager { inherit users; };
                      };
                    }
                  ];
                };


    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
      # personal
      darwinConfigurations."personal" = darwinSystemPersonal { updateHomebrew = false; };
      darwinConfigurations."personal-updatehomebrew" = darwinSystemPersonal { updateHomebrew = true; profile = "personal"; };
      # work
      darwinConfigurations."work" = darwinSystemWork { updateHomebrew = false; };
      darwinConfigurations."work-updatehomebrew" = darwinSystemWork { updateHomebrew = true; profile = "work"; };
    };
}
