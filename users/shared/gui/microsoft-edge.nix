{ pkgs, ... }:
let
  # Extension IDs from Edge Add-ons store
  extensions = [
    "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
    "kgnghhfkloifoabeaobjkgagcecbnppg" # Surfingkeys
  ];

  # Format: "extension_id;update_url" for Edge Add-ons
  extensionsList = map (
    id: "${id};https://edge.microsoft.com/extensionwebstorebase/v1/crx"
  ) extensions;

  policies = {
    ExtensionInstallForcelist = extensionsList;
  };
in
{
  home.packages = [ pkgs.microsoft-edge ];

  # User-level policies for Microsoft Edge
  xdg.configFile."microsoft-edge/policies/managed/extensions.json".text = builtins.toJSON policies;
}
