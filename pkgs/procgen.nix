{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, makeWrapper
, sfml_2
, libGL
, libGLU
, libx11
}:

# Epholys/procgen: an interactive L-System editor ("lsys").
#
# Not in nixpkgs. Upstream vendors imgui, imgui-sfml, cereal and GSL, so the
# only external dependencies are SFML 2 and OpenGL.
#
# The program hardcodes the relative paths 'config/config.json' and 'saves/',
# so it only works when the working directory contains both. The wrapper below
# creates them under $XDG_DATA_HOME and chdirs there before exec'ing.
stdenv.mkDerivation (finalAttrs: {
  pname = "procgen";
  version = "1.0.0-unstable-2020-12-02";

  src = fetchFromGitHub {
    owner = "Epholys";
    repo = "procgen";
    rev = "a238f62f06c29200d330dd40d91c87a9c7fbca4c";
    hash = "sha256-P0sUqxfsqMNzmABWv6MQ97DczqWQG7IdGuersMpW4OU=";
  };

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];

  buildInputs = [ sfml_2 libGL libGLU libx11 ];

  # Upstream declares cmake_minimum_required(VERSION 3.5), which CMake 4
  # refuses outright.
  cmakeFlags = [ (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5") ];

  # The vendored cereal 1.2.2 ships a rapidjson whose templates GCC 15 rejects
  # outright (-Wtemplate-body is an error by default).
  env.NIX_CFLAGS_COMPILE = "-Wno-template-body";

  installPhase = ''
    runHook preInstall

    install -Dm755 lsys $out/libexec/procgen/lsys

    # Default data the wrapper seeds a fresh user directory with.
    install -Dm644 $src/config/config.json -t $out/share/procgen/config
    install -Dm644 $src/saves/*.lsys -t $out/share/procgen/saves

    # Without arguments lsys starts the GUI, which reads and writes 'config/'
    # and 'saves/' relative to the working directory; with arguments it is a
    # one-shot PNG exporter taking a path, so there the user's own working
    # directory must be left alone.
    makeWrapper $out/libexec/procgen/lsys $out/bin/procgen \
      --run '
        if [ "$#" -eq 0 ]; then
          data="''${XDG_DATA_HOME:-$HOME/.local/share}/procgen"
          if [ ! -d "$data" ]; then
            mkdir -p "$data"
            cp -r --no-preserve=mode '"$out"'/share/procgen/config "$data/config"
            cp -r --no-preserve=mode '"$out"'/share/procgen/saves "$data/saves"
          fi
          mkdir -p "$data/config" "$data/saves"
          cd "$data"
        fi
      '
    ln -s $out/bin/procgen $out/bin/lsys

    runHook postInstall
  '';

  meta = {
    description = "Interactive tool to create and paint L-Systems";
    homepage = "https://github.com/Epholys/procgen";
    license = lib.licenses.gpl3Plus;
    mainProgram = "procgen";
    platforms = lib.platforms.linux;
  };
})
