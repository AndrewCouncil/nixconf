{
  ...
}:

{
  programs.firefox = {
    enable = true;

    # https://nix-community.github.io/home-manager/options.html#opt-programs.firefox.profiles
    profiles = {
      profile_0 = {
        # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
        id = 0; # 0 is the default profile; see also option "isDefault"
        name = "drew"; # name as listed in about:profiles
        isDefault = true; # can be omitted; true if profile ID is 0
        settings = {
          # specify profile-specific preferences here; check about:config for options
          "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
          "extensions.pocket.enabled" = false;
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
        };
        search = {
          engines = {
            "unduck" = {
              urls = [ { template = "https://unduck.link?q={searchTerms}"; } ];
              iconUpdateURL = "https://unduck.link/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
            };
            "Bing".metaData.hidden = true;
          };
          default = "unduck";
          privateDefault = "DuckDuckGo";
        };
      };
    };
  };
}
