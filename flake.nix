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
          packages = with pkgs; [
            dart

            # IDE / text editor
            neovim

            # Version control
            lazygit
            gitFull
            gh

            # File explorer
            yazi

            # Terminal
            zsh
            eza
            bat

            # zsh extensions
            zsh-forgit  
            zsh-fzf-tab 
            zsh-autocomplete 
            zsh-autosuggestions 
            zsh-fast-syntax-highlighting 
            zsh-fzf-history-search

            # zsh theme
            spaceship-prompt 


            # Utilities
            fzf
            tmux
          ];
          paths = pkgs.writeText ".zsh/paths.zsh" ''
export PATH="${pkgs.zsh-forgit.outPath}/bin:$PATH";
source "${pkgs.zsh-fast-syntax-highlighting.outPath}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
source "${pkgs.zsh-forgit.outPath}/share/zsh/site-functions/_git-forgit";
source "${pkgs.zsh-autocomplete.outPath}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
source "${pkgs.zsh-autosuggestions.outPath}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
source "${pkgs.zsh-fzf-tab.outPath}/share/fzf-tab/lib/zsh-ls-colors";
source "${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
source "${pkgs.spaceship-prompt.outPath}/share/zsh/site-functions/prompt_spaceship_setup";
'';

          zshrc = pkgs.writeText ".zsh/.zshrc" ''
alias _git=""
alias ls="eza --icons=always "
alias cat=bat
source .zsh/paths.zsh
HISTFILE=.zsh/.history
HISTSIZE=1000
SAVEHIST=100000
source .zsh/completions
          '';

          zshenv = pkgs.writeText ".zsh/.zshenv" ''
skip_global_compinit=1
          '';

          completions = pkgs.writeText ".zsh/.completions" ''
autoload -Uz compinit
compinit
          '';

          shellHook = ''
cp $paths .zsh/paths.zsh
cp $zshrc .zsh/.zshrc
cp $zshenv .zsh/.zshenv
cp $completions .zsh/completions
tmux setenv -g ZDOTDIR .zsh
tmux set -g default-shell ${pkgs.zsh.outPath}/bin/zsh
tmux new-session -n -t zsh
exit;
          '';
        };
      });
    };
}
