{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  llmAgentsPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in

{
  home.packages =
    (with pkgs; [
      neovim
      starship
      luarocks
      tmux
      lazygit
      lazydocker
      git-lfs
      eza
      obsidian
    ])

    # Shared CLI tools (Linux + Darwin)
    # Deduplicated from nixos/base.nix environment.systemPackages
    # and home-manager/macos.nix home.packages
    ++ (with pkgs; [
      lsof
      wget
      curl
      zip
      unzip
      btop
      fastfetch

      ripgrep
      fd
      jq
      yq
      ast-grep
      difftastic
      shellcheck
      just
      devenv
      gh
      parallel
      sqlite
      sd
      entr
      hyperfine
      cloc

      awscli2
      ngrok

      # Global Node for npx/MCP servers and editor tooling; projects pin their own via devenv.
      nodejs
      python3
      uv

      kubectl
      kustomize

      stylua
      lua-language-server
      ffmpeg
    ])

    # Linux-only packages
    ++ lib.optionals (!isDarwin) (
      with pkgs;
      [
        dbeaver-bin
        pinta
        google-chrome
        zoom-us
        postman
        slack
        telegram-desktop
        pear-desktop
        vlc
        cava
        fum
        open-webui

        nautilus
        papirus-icon-theme
        bibata-cursors
        awww
      ]
    )

    ++ (with pkgs; [
      feishin
      cliamp
    ])

    ++ lib.optionals (!isDarwin) (
      with llmAgentsPkgs;
      [
        claude-code
      ]
    )

    ++ (with llmAgentsPkgs; [
      opencode
      pi
    ]);
}
