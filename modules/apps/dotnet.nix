{ follows }:
with follows;
with dotnetCorePackages;
{
  nuke = buildDotnetGlobalTool {
    pname = "nuke";
    version = "10.1.0";
    nugetName = "Nuke.GlobalTool";
    nugetHash = "sha256-/7ET0onBQzCmqFzr64XlaS5gE7WD/lhGSRN9jbUdKHw=";
    dotnet-runtime = sdk_10_0;
    dotnet-sdk = sdk_10_0;

    meta = {
      homepage = "https://nuke.build/";
      description = "NUKE build automation global tool";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
    };
  };

  sdk = combinePackages [
    sdk_8_0
    sdk_9_0
    sdk_10_0
  ];
}
