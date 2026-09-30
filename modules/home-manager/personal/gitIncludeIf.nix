[
  {
    contents = {
      user = {
        name = "Jacob Steenblik";
        email = "jacob.steenblik@ost.ch";
      };
       commit.gpgsign = true;
       user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIASdLiS5ZPZvHf1M4pnEjqqlVI759ydOou9QUgsNrDjv";
    };
    condition = "hasconfig:remote.*.url:ssh://git@gitlab.ost.ch:45022/**";
  }
]
