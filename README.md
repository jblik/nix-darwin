# configuration
Configuration files for various services I use.

mostly nix-darwin setup
## nix-darwin setup
### first run on computer
- install nix-darwin
- `cd ~/repo/nix-darwin && sudo darwin-rebuild switch --flake .#jsteenblik`
### once it's installed
from any path you can run:
- `nix-rebuild` which will rebuild configuration (darwin-rebuild switch)
- `nix-update` which will perform a flake update and a brew upgrade then rebuild
- `nix-gc {days:10}` which performs garbage collection and store optimization
- `nix-update-gc` performs `nix-update && nix-gc` 
