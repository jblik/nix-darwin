user: [
  {
    contents.user = {
      name = "Jacob Steenblik";
      email = "jacob.steenblik@ost.ch";
      signingKey = "${user.ssh."gitlab.ost.ch".IdentityFile}.pub";
    };
    condition = "hasconfig:remote.*.url:ssh://git@gitlab.ost.ch:45022/**";
  }
  {
    contents.user = {
      name = "jblik";
      email = "88430125+jblik@users.noreply.github.com";
      signingKey = "${user.ssh."github.com".IdentityFile}.pub";
    };
    condition = "hasconfig:remote.*.url:git@github.com:*/**";
  }
  {
    contents.user = {
      name = "jblik";
      email = "jacob@steenblik.ch";
      signingKey = "${user.ssh."git.steenblik.ch".IdentityFile}.pub";
    };
    condition = "hasconfig:remote.*.url:ssh://forgejo@git.steenblik.ch:2222/**";
  }
]
