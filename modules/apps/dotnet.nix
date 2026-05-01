{ follows }:
{
  nuke = follows.buildDotnetGlobalTool {
    pname = "Nuke.GlobalTool";
    version = "10.1.0";

    nugetSha256 = "sha256-/7ET0onBQzCmqFzr64XlaS5gE7WD/lhGSRN9jbUdKHw=";

    meta = with follows.lib; {
      #            homepage = "https://cmd.petabridge.com/index.html";
      #            changelog = "https://cmd.petabridge.com/articles/RELEASE_NOTES.html";
      #            license = licenses.unfree;
      #            platforms = platforms.linux;
    };
  };

  sdk =
    with follows.dotnetCorePackages;
    combinePackages [
      sdk_8_0
      sdk_9_0
      sdk_10_0
    ];
}
