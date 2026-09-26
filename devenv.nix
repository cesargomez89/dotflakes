{ pkgs, ... }:

{
  packages = with pkgs; [
    nixd
    nixfmt
    statix
    deadnix
    shellcheck
  ];

  git-hooks.hooks = {
    nixfmt.enable = true;
    statix.enable = true;
    deadnix.enable = true;
    shellcheck.enable = true;
  };

  scripts.lint.exec = ''
    set -e
    nixfmt --check $(git ls-files '*.nix')
    statix check .
    deadnix --fail .
    shellcheck $(git ls-files '*.sh')
  '';
}
