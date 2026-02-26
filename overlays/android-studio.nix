final: prev: {
  android-studio = prev.android-studio.overrideAttrs (_: {
    # Android Studio Panda 1 | 2025.3.1 (stable)
    # Not yet in nixpkgs; override until the package is updated.
    version = "2025.3.1.2";
    src = prev.fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/2025.3.1.2/android-studio-2025.3.1.2-linux.tar.gz";
      sha256 = "sha256-kgYPwMF/CypkCq4w/y+HnraNdPNHf53198x35S0i7OA=";
    };
  });
}
