user: {
  "--scope" = [
    {
      "--when".repositories = [ "~/work" ];
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "${user.ssh."git.internal.master.yoda.cloud".IdentityFile}.pub";
      };
    }
    {
      "--when".repositories = [ "~/work/opensource" ];
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "${user.ssh."github.com".IdentityFile}.pub";
      };
    }
    {
      "--when".repositories = [ "~/work/azure-devops" ];
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "${user.ssh."vs-ssh.visualstudio.com:v3".IdentityFile}.pub";
      };
    }
    {
      "--when".repositories = [ "~/nix-darwin" ];
      user = {
        name = "jblik";
        email = "jblik@noreply.codeberg.org";
      };
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "${user.ssh."codeberg.org".IdentityFile}.pub";
      };
    }
  ];
}
