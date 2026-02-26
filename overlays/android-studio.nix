final: prev: {
  # Android Studio Panda 1 | 2025.3.1 (stable)
  # Not yet in nixpkgs stable; override until the package is updated.
  android-studio =
    let
      # Wrap xdg-open to use xdg-desktop-portal via gdbus instead of
      # trying to chmod/exec the browser's .desktop file directly. This is
      # the standard fix for NixOS FHS envs, see nixpkgs#160923.
      xdgOpenPortal = prev.writeShellScriptBin "xdg-open" ''
        exec ${prev.glib}/bin/gdbus call \
          --session \
          --dest org.freedesktop.portal.Desktop \
          --object-path /org/freedesktop/portal/desktop \
          --method org.freedesktop.portal.OpenURI.OpenURI \
          "" "$1" '{}'
      '';

      buildFHSEnvWithPortal = args: prev.buildFHSEnv (args // {
        multiPkgs = pkgs: (args.multiPkgs or (_: []) pkgs) ++ [ xdgOpenPortal ];
      });
    in
    prev.callPackage
      (import (prev.path + "/pkgs/applications/editors/android-studio/common.nix") {
        channel = "stable";
        pname = "android-studio";
        version = "2025.3.1.2";
        sha256Hash = "sha256-kgYPwMF/CypkCq4w/y+HnraNdPNHf53198x35S0i7OA=";
      })
      {
        fontsConf = prev.makeFontsConf { fontDirectories = [ ]; };
        buildFHSEnv = buildFHSEnvWithPortal;
        tiling_wm = false;
      };
}
