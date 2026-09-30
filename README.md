# nix-darwin flake

### first run on computer

the repo lives in `/etc/nix-darwin` and every user works in it directly, sharing the same jj/git working copy.
`safe.directory` for this path is set for every user in `modules/home-manager/git.nix`.

- [install nix](https://lix.systems/install/#on-any-other-linuxmacos-system) (this is the lix installer but it's
  recommended by nix as it has an uninstaller)
- clone the repo into `/etc` and give the `staff` group write access to it:

```sh
# /etc is owned by root, so the empty target has to exist before cloning into it
sudo mkdir /etc/nix-darwin
sudo chown jblik:staff /etc/nix-darwin
# inherited, so every file git and jj create is group writable regardless of each user's umask
chmod +a "group:staff allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /etc/nix-darwin

cd /etc && git clone ssh://git@codeberg.org/jblik/nix-darwin.git
git -C /etc/nix-darwin config core.sharedRepository group
```

- `cd /etc/nix-darwin && sudo darwin-rebuild switch --flake .#default`
- `jj git init` in `/etc/nix-darwin` to colocate jj with the git repo (jj is installed by the rebuild)

### once it's installed

from any path you can run:

- `nix-rebuild` which will rebuild configuration (darwin-rebuild switch)
- `nix-update` which will perform a flake update and a brew upgrade then rebuild
- `nix-gc {days:30}` which performs garbage collection and store optimization
- `nix-update-gc` performs `nix-update && nix-gc` 
