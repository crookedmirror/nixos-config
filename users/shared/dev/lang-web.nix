{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_24
    deno
    typescript # nvim-lspconfig
    htmx-lsp # nvim-lspconfig
  ];
}
