{...}: let
  associations = {
    "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
    "application/x-wine-extension-ini" = ["helix.desktop"];
    "image/jpeg" = ["feh.desktop"];
    "image/png" = ["feh.desktop"];
    "model/stl" = ["fstl.desktop"];
    "inode/directory" = ["thunar.desktop"];
    "text/csv" = ["helix.desktop"];
    "text/html" = ["google-chrome.desktop"];
    "text/markdown" = ["helix.desktop"];
    "text/plain" = ["helix.desktop"];
    "video/x-matroska" = ["mpv.desktop"];
    "x-scheme-handler/msteams" = ["teams.desktop"];
    "x-scheme-handler/slack" = ["slack.desktop"];
    "x-scheme-handler/http" = ["google-chrome.desktop"];
    "x-scheme-handler/https" = ["google-chrome.desktop"];
    "x-scheme-handler/about" = ["google-chrome.desktop"];
    "x-scheme-handler/unknown" = ["google-chrome.desktop"];
    "x-scheme-handler/postman" = ["Postman.desktop"];
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
