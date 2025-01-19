{ pkgs, ... }: {
  home.packages = with pkgs; [
    gitMinimal
    ripgrep
    fd
    htop
    tmux
    neofetch
  ];

  home.file.".config/tmux/tmux.conf".text = ''
    set -g default-terminal "screen-256color"
    set -g mouse on
  '';
}
