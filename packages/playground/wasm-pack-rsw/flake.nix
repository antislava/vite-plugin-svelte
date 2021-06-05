{
  description = "A Rust WASM devShell";

  inputs = {
    # nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
    # crate2nix = { url = "github:kolloch/crate2nix"; flake = false; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };

  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      let rustExt =
        (pkgs.rust-bin.selectLatestNightlyWith (
          toolchain: toolchain.default.override {
            extensions = [
              "rust-src"
              "rust-analysis"
              "rustfmt-preview"
              "clippy-preview"
            ];
            targets = [ "wasm32-unknown-unknown" ];
          }));
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            openssl
            pkgconfig
            rustExt
            wasm-bindgen-cli
            wasm-pack
            cargo-watch
            cargo-make
            jq
            exa
          ];

          shellHook = ''
            export PS1='\n\[\033[1;34m\][$(git rev-parse --abbrev-ref HEAD):\[\033[1;32m\]\w]\$\[\033[0m\] '
          '' +
          ''
            export RUST_BACKTRACE=1
            export RUST_SRC_PATH_NIX="${rustExt}"

            source ${rustExt}/etc/bash_completion.d/cargo

          '' +
          ''
            export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
            export PUPPETEER_EXECUTABLE_PATH=`which chromium`
          '' +
          ''
            echo ${pkgs.rustc}
            echo ${pkgs.cargo}
            echo ${pkgs.rust-analyzer}
            echo ${pkgs.wasm-bindgen-cli}
            echo ${pkgs.wasm-pack}
            echo ${pkgs.cargo-watch}
            echo ${pkgs.cargo-make}

            echo Updating rust-analyzer in coc-settings...
            mkdir -p .vim
            coc_settings=.vim/coc-settings.json;
            [[ ! -s $coc_settings ]] && echo '{}' > $coc_settings;
            res=`jq '."rust-analyzer.server.path"="${pkgs.rust-analyzer}/bin/rust-analyzer"' $coc_settings`;
            echo $res > $coc_settings;
            cat $coc_settings

            echo Updating rust-analyzer in vscode settings...
            mkdir -p .vscode
            vsc_settings=.vscode/settings.json;
            [[ ! -s $vsc_settings ]] && echo '{}' > $vsc_settings;
            res=`jq '."rust-analyzer.server.path"="${pkgs.rust-analyzer}/bin/rust-analyzer"' $vsc_settings`;
            echo $res > $vsc_settings;
            cat $vsc_settings

          '';
        };
      }
    );
}
