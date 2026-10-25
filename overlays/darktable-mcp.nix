final: prev:
let
  # darktable-mcp (the official MCP server) is only in darktable master so
  # far, not in any release. Build master and expose only the darktable-mcp
  # binary, so the darktable GUI from nixpkgs (and its library) stays on the
  # stable release. Drop this once a release ships darktable-mcp.
  darktable-master = final.unstable.darktable.overrideAttrs (old: {
    version = "5.7.0-unstable-2026-10-25";

    src = final.fetchFromGitHub {
      owner = "darktable-org";
      repo = "darktable";
      rev = "cfd6aae58e52ede6a4710c6198dc636b46b0c21e";
      fetchSubmodules = true;
      hash = "sha256-ki6BzFiBGoYIRnvC5PNVcfBZ2ZkoUUVHvm8ekbVulMY=";
    };

    # master requires libarchive unconditionally (5.6 only with USE_AI).
    buildInputs = old.buildInputs ++ [ final.libarchive ];

    cmakeFlags = old.cmakeFlags ++ [
      # Not a git checkout inside the sandbox, so pin the version string.
      "-DPROJECT_VERSION=5.7.0"
      (final.lib.cmakeBool "USE_MCP" true)
    ];

    # versionCheckHook compares against `version`, which master doesn't print.
    doInstallCheck = false;
  });
  # Separate config dir shared by darktable-mcp and darktable-master, so the
  # master build never upgrades the stable darktable's library.db.
  configdir = "$HOME/.config/darktable-mcp";
in
{
  darktable-mcp = final.writeShellScriptBin "darktable-mcp" ''
    # Persistent library, so edits can be inspected with darktable-master.
    # darktable locks library.db, so close darktable-master before using this.
    exec ${darktable-master}/bin/darktable-mcp --core \
      --configdir "${configdir}" \
      --cachedir "${configdir}/cache" \
      --library "${configdir}/library.db" \
      "$@"
  '';

  darktable-master = final.writeShellScriptBin "darktable-master" ''
    exec ${darktable-master}/bin/darktable \
      --configdir "${configdir}" \
      --cachedir "${configdir}/cache" \
      "$@"
  '';
}
