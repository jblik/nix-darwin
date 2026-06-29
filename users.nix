{
  personal = {
    username = "jblik";
    homeDirectory = "/Users/jblik";
    profile = "personal";
    git = {
      name = "Jacob Steenblik";
      email = "jacob@steenblik.org";
    };
    ssh = {
      "github.com" = {
        User = "git";
        IdentityFile = "/Users/jblik/.ssh/github";
      };
      "gitlab.ost.ch" = {
        User = "git";
        IdentityFile = "/Users/jblik/.ssh/school_gitlab";
      };
      "codeberg.org" = {
        User = "git";
        IdentityFile = "/Users/jblik/.ssh/jblik_forgejo";
      };
    };
  };
  work = {
    username = "wookie";
    homeDirectory = "/Users/wookie";
    profile = "work";
    git = {
      name = "Jacob Steenblik";
      email = "jacob.steenblik@yarowa.com";
    };
    ssh = {
      "github.com" = {
        User = "git";
        IdentityFile = "/Users/wookie/.ssh/id_ed25519";
      };
      "vs-ssh.visualstudio.com:v3" = {
        User = "jacob.steenblik@yarowa.com";
        IdentityFile = "/Users/wookie/.ssh/azure_devops";
      };
      "Host git.internal.master.yoda.cloud" = {
        User = "git";
        IdentityFile = "/Users/wookie/.ssh/yarowa_forgejo";
      };
      "codeberg.org" = {
        User = "git";
        IdentityFile = "/Users/jblik/.ssh/jblik_forgejo";
      };
    };
  };
}
