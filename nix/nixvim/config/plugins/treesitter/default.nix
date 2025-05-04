{ pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;

    settings = {
      indent = {
        enable = true;
      };
      highlight = {
        enable = true;
      };

      ensure_installed = [
        "go"
        "gomod"
        "gosum"
        "gowork"
        "python"
        "typescript"
        "tsx"
        "javascript"
        "markdown"
        "markdown_inline"
      ];

    };

    folding = true;
    nixvimInjections = true;
    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
  };
}
