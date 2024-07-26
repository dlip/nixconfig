{pkgs, ...}: {
  home.sessionVariables = {
    GOPATH = "$HOME/go";
    PATH = "$HOME/code/nixconfig/bin:$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$HOME/.cargo/bin:/etc/profiles/per-user/$USER/bin:/opt/homebrew/bin:$PATH";
    EDITOR = "nvim";
    LANG = "en_AU.UTF-8";
    LC_ALL = "en_AU.UTF-8";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    # STEEL_HOME = "${pkgs.steel}/lib";
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1"; # Fixes libicu error in osu!
  };
}
