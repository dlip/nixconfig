{...}: let
  associations = {
    "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
    "text/plain" = ["helix.desktop"];
    "text/markdown" = ["helix.desktop"];
    "text/csv" = ["helix.desktop"];
    "image/jpeg" = ["feh.desktop"];
    "image/png" = ["feh.desktop"];
    "x-scheme-handler/msteams" = ["teams.desktop"];
    "x-scheme-handler/slack" = ["slack.desktop"];
    "inode/directory" = ["thunar.desktop"];
    "x-scheme-handler/http" = ["google-chrome.desktop"];
    "x-scheme-handler/https" = ["google-chrome.desktop"];
    "text/html" = ["google-chrome.desktop"];
    "x-scheme-handler/about" = ["google-chrome.desktop"];
    "x-scheme-handler/unknown" = ["google-chrome.desktop"];
    "video/x-matroska" = ["mpv.desktop"];
  };
in {
  xdg.desktopEntries.helix = {
    name = "helix";
    genericName = "Helix Text Editor";
    exec = "alacritty -e hx %u";
  };
  xdg.mimeApps = {
    enable = true;
    associations.added = associations;
    defaultApplications = associations;
  };
}
