{
  buildDotnetGlobalTool,
  dotnetCorePackages,
  lib,
}:
with dotnetCorePackages;
{
  fallout = buildDotnetGlobalTool {
    pname = "fallout";
    version = "10.4.0";
    nugetName = "Fallout.GlobalTool";
    nugetHash = "sha256-pil2hq/fz7yPizNlfiyK6yEruEfuqH22iqHKk7USG7E=";
    dotnet-runtime = sdk_10_0;
    dotnet-sdk = sdk_10_0;

    meta = {
      homepage = "https://docs.fallout.build/";
      description = "FALLOUT build automation global tool";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
    };
  };

  sdk = sdk_10_0;
}
