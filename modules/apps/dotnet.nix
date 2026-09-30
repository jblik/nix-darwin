{pkgs-unstable}:
{
#environment.variables.DOTNET_ROOT = "$(dirname $(realpath $(which dotnet)))";
sdk =     (
               with pkgs-unstable.dotnetCorePackages;
               combinePackages [
                 sdk_8_0
                 sdk_9_0
                 sdk_10_0
               ]
             );
}