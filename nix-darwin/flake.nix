{
  description = "My nix-darwin system flake";

  inputs = {
    # nix
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    # homebrew
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
    
    # todo use home manager
#    home-manager = {
#      url = "github:nix-community/home-manager";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, homebrew-argoproj }:
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
    
    system.primaryUser = username;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#jsteenblik // build only
    # $ sudo darwin-rebuild switch --flake .#jsteenblik // apply
    # $ darwin-rebuild check // to check without applying 
    darwinConfigurations.jsteenblik = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit username;
      };
      modules = [ 
          configuration # todo pass the primaryUser to the configuration instead of defining it in there
          ./modules/default.nix
          inputs.nix-homebrew.darwinModules.nix-homebrew 
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = username;
              taps = {
                "homebrew/homebrew-core"   = inputs.homebrew-core;
                "homebrew/homebrew-cask"   = inputs.homebrew-cask;
                # todo these two may not be needed
                "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                "argoproj/homebrew-tap"    = inputs.homebrew-argoproj;
              };
              autoMigrate = true;
              mutableTaps = true; # set to false if you want to disable brew tap
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

