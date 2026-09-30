user: {
  "--scope" = [
    {
      "--when".repositories = [ "~/projects" ];
      user = {
        name = "jblik";
        email = "jblik@noreply.codeberg.org";
      };
      signing.key = "${user.ssh."codeberg.org".IdentityFile}.pub";
    }
    {
      "--when".repositories = [ "~/projects/github" ];
      user = {
        name = "jblik";
        email = "88430125+jblik@users.noreply.github.com";
      };
      signing.key = "${user.ssh."github.com".IdentityFile}.pub";
    }
    {
      "--when".repositories = [ "~/school" ];
      user = {
        name = "Jacob Steenblik";
        email = "jacob.steenblik@ost.ch";
      };
      signing.key = "${user.ssh."gitlab.ost.ch".IdentityFile}.pub";
    }
  ];
}
