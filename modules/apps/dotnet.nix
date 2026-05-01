{ follows }:
{
  nuke = follows.buildDotnetGlobalTool {
    pname = "nuke";
    version = "10.1.0";
    nugetName = "Nuke.GlobalTool";
    nugetHash = "sha256-/7ET0onBQzCmqFzr64XlaS5gE7WD/lhGSRN9jbUdKHw=";

    dotnet-sdk = follows.dotnetCorePackages.sdk_10_0;
    dotnet-runtime = follows.dotnetCorePackages.sdk_10_0;

    meta = with follows.lib; {
      homepage = "https://nuke.build/";
      description = "NUKE build automation global tool";
      license = licenses.mit;
      platforms = platforms.darwin;
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
