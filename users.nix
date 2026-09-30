{
  personal = {
    username = "jblik";
    homeDirectory = "/Users/jblik";
    profile = "personal";
    git = {
      name = "Jacob Steenblik";
      email = "jacob@steenblik.ch";
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
      "git.steenblik.ch" = {
        User = "forgejo";
        IdentityFile = "/Users/jblik/.ssh/git.steenblik.ch";
      };
      "nixos-server" = {
        HostName = "192.168.1.100";
        User = "jblik";
        IdentityFile = "/Users/jblik/.ssh/nixos_server";
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
      "ssh.dev.azure.com" = {
        User = "git";
        IdentityFile = "/Users/wookie/.ssh/azure_devops";
      };
      "vs-ssh.visualstudio.com" = {
        User = "jarowa";
        IdentityFile = "/Users/wookie/.ssh/azure_devops";
      };
      "git.internal.master.yoda.cloud" = {
        User = "git";
        IdentityFile = "/Users/wookie/.ssh/yarowa_forgejo";
      };
      "codeberg.org" = {
        User = "git";
        IdentityFile = "/Users/wookie/.ssh/jblik_forgejo";
      };
      "git.steenblik.ch" = {
        User = "forgejo";
        IdentityFile = "/Users/wookie/.ssh/git.steenblik.ch";
      };
    };
  };
}
