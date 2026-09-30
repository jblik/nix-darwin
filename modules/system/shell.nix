{ user, ... }:

let
  flakePath = "~/nix-darwin";
  flakeRef = "${flakePath}#${user.profile}";
  flakeUpdateRef = "${flakeRef}-updatehomebrew";
in
{
  environment = {
    variables = {
      EDITOR = "vim";
      OLLAMA_NO_CLOUD = "true";
      DOTNET_ROOT = "$(dirname $(realpath $(which dotnet)))";
    };

    shellAliases = {
      nix-rebuild = "sudo darwin-rebuild switch --flake ${flakeRef}";
      k = "kubectl";
      ktx = "kubectx";
      kns = "kubens";
    };

    systemPath = [
      "/opt/homebrew/bin"
      #    todo: maybe the tools are already in the path?
      "$DOTNET_ROOT:$DOTNET_ROOT/tools"
    ];
  };

  programs.zsh.interactiveShellInit = ''
    nix-update() {
      sudo -v
      nix flake update --flake ${flakePath} || return 1

      if ! git -C ${flakePath} diff --quiet -- ${flakePath}/flake.lock; then
        git -C ${flakePath} add ${flakePath}/flake.lock || return 1
        git -C ${flakePath} commit -m "update flake.lock" || return 1
      fi

      sudo darwin-rebuild switch --flake ${flakeUpdateRef}
    }
    nix-update-gc() {
      local days="''${1:-10}"
      nix-update
      nix-gc "''${days}"
    }
    nix-gc() {
      local days="''${1:-10}"
      echo "Removing generations older than ''${days}d..."
      nix-collect-garbage --delete-older-than "''${days}d"
      echo "Optimizing Nix store..."
      nix-store --optimise
    }
  '';
}
