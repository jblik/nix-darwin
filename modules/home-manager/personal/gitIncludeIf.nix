user: [
  {
    contents = {
      user = {
        name = "Jacob Steenblik";
        email = "jacob.steenblik@ost.ch";
      };
      commit.gpgsign = true;
      user.signingKey = "${user.ssh."gitlab.ost.ch".IdentityFile}.pub";
    };
    condition = "hasconfig:remote.*.url:ssh://git@gitlab.ost.ch:45022/**";
  }
  {
    contents = {
      user = {
        name = "jblik";
        email = "88430125+jblik@users.noreply.github.com";
      };
    };
    condition = "hasconfig:remote.*.url:git@github.com:*/**";
  }
]
