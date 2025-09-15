{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.clearOnShutdown_v2.cache" = false;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.sanitize.pending" = "[]";
      "privacy.sanitize.sanitizeOnShutdown" = false;
      "browser.startup.page" = 3;
    };
    profiles.default.extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      localcdn
      wappalyzer
      darkreader
      google-container
      octotree
      #pywalfox uncomment for theme changing
      surfingkeys
    ];
    profiles.default.search = {
      force = true;
      default = "4GET.ch";

      engines = {
        #TODO: Hode Mojeek, MetaGer, StartPage and DuckDuckGo Lite
        "bing".metaData.hidden = true;
        "google".metaData.hidden = true;
        "duckduckgo".metaData.hidden = true;
        "wikipedia".metaData.alias = "wen";
        "GitHub" = {
          urls = [
            {
              template = "https://github.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
                {
                  name = "type";
                  value = "repositories";
                }
              ];
            }
          ];
          definedAliases = [ "gh" ];
        };
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "np" ];
        };
        "4GET.ch" = {
          urls = [
            {
              template = "https://4get.ch/web";
              params = [
                {
                  name = "s";
                  value = "{searchTerms}";
                }
                {
                  name = "scraper";
                  value = "google";
                }
                {
                  name = "nsfw";
                  value = "yes";
                }
                {
                  name = "country";
                  value = "ru";
                }
              ];
            }
          ];
        };
        "Neco LOL 4GET" = {
          urls = [
            {
              template = "https://4get.neco.lol/web";
              params = [
                {
                  name = "s";
                  value = "{searchTerms}";
                }
                {
                  name = "scraper";
                  value = "google";
                }
                {
                  name = "nsfw";
                  value = "yes";
                }
                {
                  name = "country";
                  value = "ru";
                }
              ];
            }
          ];
          definedAliases = [ "neco" ];
        };
        "Wikipedia (ru)" = {
          urls = [
            {
              template = "https://ru.wikipedia.org/w/index.php";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
                {
                  name = "go";
                  value = "%D0%9F%D0%B5%D1%80%D0%B5%D0%B9%D1%82%D0%B8";
                }
              ];
            }
          ];
          definedAliases = [ "wru" ];
        };

      };
    };
  };
}
