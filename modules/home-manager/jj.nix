{
  user,
  ...
}:
let
  profileSettings = import ./${user.profile}/jj-settings.nix user;
in
{
  programs.jujutsu = {
    enable = true;
    # todo: can we set the package to null to keep the settings but not install per user?
    settings = {
      user = user.git;
      signing = {
        behavior = "own";
        backend = "ssh";
      };
      revset-aliases = {
        "immutable_heads()" =
          ''builtin_immutable_heads() | remote_bookmarks(glob:"release/*", remote=exact:"origin")'';
      };
    }
    // profileSettings
    // {
      "--scope" = profileSettings."--scope" ++ [
        {
          # jj matches the resolved path and /etc is a symlink to /private/etc
          "--when".repositories = [ "/private/etc/nix-darwin" ];
          user = {
            name = "jblik";
            email = "jblik@noreply.codeberg.org";
          };
          signing.key = "${user.ssh."codeberg.org".IdentityFile}.pub";
        }
      ];
    };
  };

  programs.jjui = {
    enable = true;
    # todo: can we set the package to null to keep the settings but not install per user?
    settings = {
      revisions = {
        log_batching = true;
        log_batch_size = 50;
        template = ''
          if(self.root(),
            format_root_commit(self),
            label(
              separate(" ",
                if(self.current_working_copy(), "working_copy"),
                if(self.immutable(), "immutable", "mutable"),
                if(self.conflict(), "conflicted"),
              ),
              concat(
                separate(" ",
                  format_short_change_id_with_change_offset(self),
                  self.bookmarks(),
                  format_short_signature(self.author()),
                  format_timestamp(commit_timestamp(self)),
                  self.tags(),
                  self.working_copies(),
                  format_short_commit_id(self.commit_id()),
                  format_commit_labels(self),
                  if(config("ui.show-cryptographic-signatures").as_boolean(),
                    format_short_cryptographic_signature(self.signature())
                  ),
                ) ++ "\n",
                separate(" ",
                  if(self.empty(), empty_commit_marker),
                  if(self.description(),
                    self.description().first_line(),
                    label(if(self.empty(), "empty"), description_placeholder),
                  ),
                ) ++ "\n",
              ),
            ),
          )
        '';
      };
    };
  };
}
