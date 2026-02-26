final: prev: {
  # Android Studio Panda 1 | 2025.3.1 (stable)
  # Not yet in nixpkgs stable; override until the package is updated.
  android-studio =
    let
      studio = prev.callPackage
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
    in
    # JetBrains IDEs try to make the browser's .desktop file executable,
    # which fails on the read-only Nix store. Setting BROWSER to the profile
    # symlink (writable path) bypasses that code path entirely.
    prev.symlinkJoin {
      name = "android-studio-${studio.version}";
      paths = [ studio ];
      buildInputs = [ prev.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/android-studio \
          --set BROWSER "$HOME/.nix-profile/bin/firefox"
      '';
    };
}
