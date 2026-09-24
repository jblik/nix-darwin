{
  config,
  user,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        UseKeychain = "yes";
      };
    }
    // user.ssh;
  };

  launchd.agents.ssh-add = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/ssh-add"
        "--apple-load-keychain"
      ];
      RunAtLoad = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/ssh-add.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/ssh-add.err";
    };
  };
}
