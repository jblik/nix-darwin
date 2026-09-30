# nix-darwin flake
### first run on computer
- [install nix](https://lix.systems/install/#on-any-other-linuxmacos-system) (this is the lix installer but it's recommended by nix as it has an uninstaller) 
- `cd ~/nix-darwin && sudo darwin-rebuild switch --flake .#personal`
### once it's installed
from any path you can run:
- `nix-rebuild` which will rebuild configuration (darwin-rebuild switch)
- `nix-update` which will perform a flake update and a brew upgrade then rebuild
- `nix-gc {days:10}` which performs garbage collection and store optimization
- `nix-update-gc` performs `nix-update && nix-gc` 
