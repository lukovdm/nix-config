final: prev: {
  # Upstream's android-studio, with xdg-open routed through the portal.
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
    prev.android-studio.override {
      buildFHSEnv = buildFHSEnvWithPortal;
    };
}
