user: [
  {
    contents = {
      commit.gpgsign = true;
      user.signingKey = "${user.ssh."git.internal.master.yoda.cloud".IdentityFile}.pub";
    };
    condition = "hasconfig:remote.*.url:git@git.internal.master.yoda.cloud:**";
  }
]
