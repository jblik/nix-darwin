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
]
