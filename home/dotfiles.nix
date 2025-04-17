{ config, lib, pkgs, ... }:

let
  dotfilesPath = config.home.homeDirectory + "/.git_installs/nix-config/dotfiles";
  mkOutOfStoreLink = relPath: config.lib.file.mkOutOfStoreSymlink ("${dotfilesPath}/${relPath}");
in
{
  home.file = {
    ".zshrc".source = mkOutOfStoreLink "zshrc";
    ".bash_profile".source = mkOutOfStoreLink "bash_profile";
    ".gitconfig".source = mkOutOfStoreLink "gitconfig";
    ".config/nvim".source = mkOutOfStoreLink "config/nvim";
    ".tmux.conf".source = mkOutOfStoreLink "tmux.conf";
    ".p10k.zsh".source = mkOutOfStoreLink "p10k.zsh";
    ".gitignore".source = mkOutOfStoreLink "gitignore";
    ".pythonstartup.py".source = mkOutOfStoreLink "pythonstartup.py";
    ".config/ranger/rc.conf".source = mkOutOfStoreLink "config/ranger/rc.conf";
    ".config/ranger/scope.sh".source = mkOutOfStoreLink "config/ranger/scope.sh";
    ".config/ranger/colorschemes/dracula.py".source = mkOutOfStoreLink "config/ranger/colorschemes/dracula.py";
    ".config/zathura/zathurarc".source = mkOutOfStoreLink "config/zathura/zathurarc";
    ".config/kitty/kitty.conf".source = mkOutOfStoreLink "config/kitty/kitty.conf";
    ".config/kitty/dracula.conf".source = mkOutOfStoreLink "config/kitty/dracula.conf";
    ".ssh/config".source = mkOutOfStoreLink "ssh/config";
    ".scripts".source = mkOutOfStoreLink "scripts";
    ".config/ranger/plugins/ranger_devicons".source = pkgs.fetchFromGitHub {
      owner = "alexanderjeurissen";
      repo = "ranger_devicons";
      rev = "main";
      sha256 = "0d0r4wy5y2fymclig7fqybbxiar7vd0rq55bscxq8656dxw7fkkj";
    };
  };

}
