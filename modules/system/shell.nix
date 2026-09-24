{
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
      "/opt/homebrew/bin"
      # todo: careful with spaces!
    ];

    variables = {
      EDITOR = "vim";
      OLLAMA_NO_CLOUD = "true";
    };
  };
}
