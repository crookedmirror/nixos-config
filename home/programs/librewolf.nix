{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.sanityze.sanityzeOnShutdown" = false;
      "privacy.clearOnShutdown_v2.cache" = false;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;

    };
    profiles.default.extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      localcdn
      wappalyzer
      darkreader
      google-container
      pywalfox
      surfingkeys
    ];
    profiles.default.search = {
      force = true;
      default = "Nadeko 4GET";

      engines = {
        "bing".metaData.hidden = true;
        "google".metaData.hidden = true; # TODO: not working. Google needs special treatment
        "ddg".metaData.hidden = true;
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
        "Nadeko 4GET" = {
          urls = [
            {
              template = "https://4get.nadeko.net/web";
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
