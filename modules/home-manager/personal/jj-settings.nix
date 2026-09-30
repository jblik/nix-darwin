user: {
  "--scope" = [
    {
      "--when".repositories = [ "~/projects" ];
      user = {
        name = "Jacob Steenblik";
        email = "jacob@steenblik.ch";
      };
      signing.key = "${user.ssh."git.steenblik.ch".IdentityFile}.pub";
    }
    {
      "--when".repositories = [ "~/projects/github" ];
      user = {
        name = "Jacob Steenblik";
        email = "jacob@steenblik.ch";
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
