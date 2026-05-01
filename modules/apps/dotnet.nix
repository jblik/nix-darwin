{ follows }:
with follows;
{
  nuke = buildDotnetGlobalTool {
    pname = "nuke";
    version = "10.1.0";
    nugetName = "Nuke.GlobalTool";
    nugetHash = "sha256-/7ET0onBQzCmqFzr64XlaS5gE7WD/lhGSRN9jbUdKHw=";
    dotnet-sdk = dotnetCorePackages.sdk_10_0;
    dotnet-runtime = dotnetCorePackages.sdk_10_0;

    meta = {
      homepage = "https://nuke.build/";
      description = "NUKE build automation global tool";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
    };
  };

  sdk = dotnetCorePackages.combinePackages [
    dotnetCorePackages.sdk_8_0
    dotnetCorePackages.sdk_9_0
    dotnetCorePackages.sdk_10_0
  ];
}
