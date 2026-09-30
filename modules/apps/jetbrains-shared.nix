{ lib, pkgs, ... }:
let
  installLocation = "/Applications/Jetbrains";

  sharedAce = "group:admin allow ${
    lib.concatStringsSep "," [
      "list"
      "add_file"
      "search"
      "delete"
      "add_subdirectory"
      "delete_child"
      "readattr"
      "writeattr"
      "readextattr"
      "writeextattr"
      "readsecurity"
      "file_inherit"
      "directory_inherit"
    ]
  }";

  sharePerms = pkgs.writeShellScript "jetbrains-share-perms" ''
    set -eu

    /bin/mkdir -p "${installLocation}"

    /bin/ls -lde "${installLocation}" | /usr/bin/grep -q file_inherit \
      || /bin/chmod +a "${sharedAce}" "${installLocation}"

    set +e
    /usr/bin/find "${installLocation}" ! -group admin -exec /usr/sbin/chown -h :admin {} +
    /usr/bin/find "${installLocation}" ! -perm -g+w -exec /bin/chmod -h g+w {} +
    /usr/bin/find "${installLocation}" -type d ! -perm -g+s -exec /bin/chmod g+s {} +
    exit 0
  '';
in
{
  system.activationScripts.postActivation.text = ''
    echo "sharing ${installLocation} between users..."
    ${sharePerms}
  '';
}
