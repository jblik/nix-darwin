{
  user,
  ...
}:
{
  programs.jujutsu = {
    enable = true;
    # todo:::
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
    // import ./${user.profile}/jj-settings.nix user;
  };

  programs.jjui = {
    enable = true;
    # todo:
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
