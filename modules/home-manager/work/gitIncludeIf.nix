user: [
  {
    contents = {
      commit.gpgsign = true;
      user.signingKey = "${user.ssh."git.internal.master.yoda.cloud".IdentityFile}.pub";
    };
    condition = "hasconfig:remote.*.url:git@git.internal.master.yoda.cloud:*/**";
  }
  {
    contents = {
      commit.gpgsign = true;
      user.signingKey = "${user.ssh."ssh.dev.azure.com".IdentityFile}.pub";
    };
    condition = "hasconfig:remote.*.url:git@ssh.dev.azure.com:*/**";
  }
  {
    contents = {
      commit.gpgsign = true;
      user.signingKey = "${user.ssh."vs-ssh.visualstudio.com".IdentityFile}.pub";
    };
    condition = "hasconfig:remote.*.url:jarowa@vs-ssh.visualstudio.com:*/**";
  }
]
