{
  ...
}:
{
  environment = {
    systemPath = [
      "/opt/homebrew/bin"
      # todo: careful with spaces!
    ];

    variables = {
      EDITOR = "vim";
      OLLAMA_NO_CLOUD = "true";
    };
  };

  # oh-my-zsh and powerlevel10k from home-manager already run compinit and set the prompt
  programs.zsh = {
    enableGlobalCompInit = false;
    promptInit = "";
  };
}
