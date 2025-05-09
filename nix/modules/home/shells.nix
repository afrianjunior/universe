{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "systemd"
        "zsh-autosuggestions"
      ];
      theme = "robbyrussell";
    };

    shellAliases = {
      ll = "ls -l";
    };
  };
}
