{
  users,
  ...
}:
{
  environment = {
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ...";
      k = "kubectl";
      ktx = "kubectx";
      kns = "kubens";
      tf = "terraform";
    };

    systemPath = [
      "${users.personal.homeDirectory}/.local/bin"
      "${users.work.homeDirectory}/.local/bin"
      "/opt/homebrew/bin"
      "$DOTNET_ROOT:$DOTNET_ROOT/tools"
      # todo: iterate
      "${users.personal.homeDirectory}/.dotnet/tools" # todo: could build my global tools in nix as well
      "${users.work.homeDirectory}/.dotnet/tools"
      # todo: careful with spaces!
    ];

    variables = {
      EDITOR = "vim";
      OLLAMA_NO_CLOUD = "true";
      DOTNET_ROOT = "$(dirname $(realpath $(which dotnet)))";
    };
  };
}
