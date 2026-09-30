{ pkgs, lib, ... }:

pkgs.stdenv.mkDerivation {
  pname = "gnome-shell-extension-bar-enhanced";
  version = "4.7.0";

  src = pkgs.fetchFromGitHub {
    owner = "MrVanguardia";
    repo = "Bar-Enhanced";
    rev = "880ab9b5d8cfd75c29a8afb4c572ce7f113b1455";
    hash = "sha256-SOMOukAWHwyxzpoy9sRjrI/e1NA8L6i7MBI7EcSlZ4I=";
  };

  nativeBuildInputs = [ pkgs.glib ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r bar-enhanced@mrvanguardia $out/share/gnome-shell/extensions/
    glib-compile-schemas $out/share/gnome-shell/extensions/bar-enhanced@mrvanguardia/schemas
    runHook postInstall
  '';

  passthru.extensionUuid = "bar-enhanced@mrvanguardia";
  passthru.extensionPortalSlug = "bar-enhanced";

  meta = {
    description = "GNOME top bar theming with floating Islands style, GNOME 50 compatible";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
