{
  environment = {
    shellAliases = {
      k = "kubectl";
      ktx = "kubectx";
      kns = "kubens";
    };

    systemPath = [
      "/opt/homebrew/bin"
      #    todo: maybe the tools are already in the path?
      "$DOTNET_ROOT:$DOTNET_ROOT/tools"
    ];

    variables = {
      EDITOR = "vim";
      OLLAMA_NO_CLOUD = "true";
      DOTNET_ROOT = "$(dirname $(realpath $(which dotnet)))";
    };
  };
}
