user: {
  signing = {
    behavior = "own";
    backend = "ssh";
    key = "${user.ssh."git.internal.master.yoda.cloud".IdentityFile}.pub";
  };
}
