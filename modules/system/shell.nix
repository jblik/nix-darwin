{
  users,
  ...
}
:
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
      "/opt/homebrew/bin"
      "$DOTNET_ROOT:$DOTNET_ROOT/tools"
      # todo: iterate
      "${users.personal.homeDirectory}/.dotnet/tools"
      "${users.work.homeDirectory}/.dotnet/tools"
    ];

    variables = {
      EDITOR = "vim";
      OLLAMA_NO_CLOUD = "true";
      DOTNET_ROOT = "$(dirname $(realpath $(which dotnet)))";
    };
  };
}
