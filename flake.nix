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

    outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, homebrew-argoproj, home-manager }:

    let
    system = "aarch64-darwin"; 
    username = "jsteenblik";
    homeDirectory = "/Users/${username}";

    pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
    };

    configuration = { pkgs, ... }: {
        nix.settings.experimental-features = "nix-command flakes";

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        system.primaryUser = username;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = system;
    };
    
    myDarwinConfiguration = { homebrewUpdate ? false }: {}
        nix-darwin.lib.darwinSystem {
            specialArgs = {
                inherit pkgs-unstable username homeDirectory;
            };
            modules = [ 
                configuration # todo pass the primaryUser to the configuration instead of defining it in there
                ./modules
                {
                    homebrewUpdate.enable = homebrewUpdate;
                }
                home-manager.darwinModules.home-manager 
                {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        verbose = true;
                        backupFileExtension = "backup";
                    };

                    home-manager.users.${username} = { pkgs, lib, ... }:
                    {
                        programs.home-manager.enable = true;
                        home.stateVersion = "25.11";
                        home.username = username;
                        home.homeDirectory = lib.mkForce "/Users/${username}";
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
                            "homebrew/homebrew-core"   = inputs.homebrew-core;
                            "homebrew/homebrew-cask"   = inputs.homebrew-cask;
                            "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                            "argoproj/homebrew-tap"    = inputs.homebrew-argoproj;
                        };
                        autoMigrate = true;
                        mutableTaps = true;
                    };
                }
            ];
        };

    in
    {
        darwinConfigurations.jsteenblik = myDarwinConfiguration {
            homebrewUpdate = false;
        };
        darwinConfigurations.jsteenblik-updatehomebrew = myDarwinConfiguration {
            homebrewUpdate = true;
        };
    };
}

