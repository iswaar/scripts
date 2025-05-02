{
  description = "A nix flake for building my scripts";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          shellHook = ''
ls;
zsh;
exit;
          '';
          packages = with pkgs; [
            dart

            # IDE / text editor
            neovim

            # Version control
            lazygit
            gitFull

            # File explorer
            yazi
            yaziPlugins.lazygit

            # Terminal
            zsh

            # zsh extensions
            zsh-forgit
            zsh-vi-mode
            zsh-fzf-tab
            zsh-completions
            zsh-autocomplete
            zsh-fast-syntax-highlighting
            zsh-fzf-history-search

            # zsh theme
            spaceship-prompt


            # Utilities
            fzf
            tmux
          ];
        };
      });
    };
}
