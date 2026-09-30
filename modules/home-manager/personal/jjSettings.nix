user: {
  "--scope" = [
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
    {
      "--when".repositories = [ "~/projects/github" ];
      user = {
        name = "jblik";
        email = "88430125+jblik@users.noreply.github.com";
      };
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "${user.ssh."github.com".IdentityFile}.pub";
      };
    }
    {
      "--when".repositories = [ "~/school" ];
      user = {
        name = "Jacob Steenblik";
        email = "jacob.steenblik@ost.ch";
      };
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "${user.ssh."gitlab.ost.ch".IdentityFile}.pub";
      };
    }
  ];
}
