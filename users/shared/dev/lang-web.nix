{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_20

    # required by personal nvim config
    nodePackages.ts-node # nvim-dap
    typescript # nvim-lspconfig
  ];
}
