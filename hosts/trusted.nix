{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tailscale
  ];

  services.dropbox.enable = true;
}
