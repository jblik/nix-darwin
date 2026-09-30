user: {
  "--scope" = [
    {
      "--when".repositories = [ "~/work" ];
      signing.key = "${user.ssh."git.internal.master.yoda.cloud".IdentityFile}.pub";
    }
    {
      "--when".repositories = [ "~/work/opensource" ];
      signing.key = "${user.ssh."github.com".IdentityFile}.pub";
    }
    {
      "--when".repositories = [ "~/work/azure-devops" ];
      signing.key = "${user.ssh."vs-ssh.visualstudio.com".IdentityFile}.pub";
    }
  ];
}
