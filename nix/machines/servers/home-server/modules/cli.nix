{ pkgs, ... }: {
  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    exa
    htop
    tmux
  ];

  home.file.".config/tmux/tmux.conf".text = ''
    set -g default-terminal "screen-256color"
    set -g mouse on
  '';
}
