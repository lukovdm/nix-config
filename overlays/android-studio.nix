final: prev: {
  # Android Studio Panda 1 | 2025.3.1 (stable)
  # Not yet in nixpkgs stable; override until the package is updated.
  android-studio = prev.callPackage
    (import (prev.path + "/pkgs/applications/editors/android-studio/common.nix") {
      channel = "stable";
      pname = "android-studio";
      version = "2025.3.1.2";
      sha256Hash = "sha256-kgYPwMF/CypkCq4w/y+HnraNdPNHf53198x35S0i7OA=";
    })
    {
      fontsConf = prev.makeFontsConf { fontDirectories = [ ]; };
      inherit (prev) buildFHSEnv;
      tiling_wm = false;
    };
}
