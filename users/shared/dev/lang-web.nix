{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_20

    deno

    nodePackages.ts-node # nvim-dap
    typescript # nvim-lspconfig
  ];
}
