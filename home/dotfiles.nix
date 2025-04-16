{ config, lib, pkgs, ... }:

let
  dotfilesPath = config.home.homeDirectory + "/.git_installs/nix-config/dotfiles";
  mkOutOfStoreLink = relPath: config.lib.file.mkOutOfStoreSymlink ("${dotfilesPath}/${relPath}");
in
{
  home.file = {
    ".zshrc".source = mkOutOfStoreLink "zshrc";
    ".gitconfig".source = mkOutOfStoreLink "gitconfig";
    ".config/nvim".source = mkOutOfStoreLink "config/nvim";
    ".config/kitty/kitty.conf".source = mkOutOfStoreLink "config/kitty/kitty.conf";
    ".config/ranger/rc.conf".source = mkOutOfStoreLink "config/ranger/rc.conf";
    ".tmux.conf".source = mkOutOfStoreLink "tmux.conf";
    ".p10k.zsh".source = mkOutOfStoreLink "p10k.zsh";
    ".gitignore".source = mkOutOfStoreLink "gitignore";
    ".pythonstartup.py".source = mkOutOfStoreLink "pythonstartup.py";
    ".config/ranger/colorschemes/dracula.py".source = mkOutOfStoreLink "config/ranger/colorschemes/dracula.py";
    ".config/zathura/zathurarc".source = mkOutOfStoreLink "config/zathura/zathurarc";
    ".config/kitty/dracula.conf".source = mkOutOfStoreLink "config/kitty/dracula.conf";
    ".ssh/config".source = mkOutOfStoreLink "ssh/config";
    ".scripts".source = mkOutOfStoreLink "scripts";
  };
}
