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
      # todo
    };
  };
}
