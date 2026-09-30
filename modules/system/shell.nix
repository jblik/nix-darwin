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
}
