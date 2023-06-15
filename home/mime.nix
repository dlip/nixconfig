{...}: let
  associations = {
    "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
    "text/plain" = ["helix.desktop"];
    "text/markdown" = ["helix.desktop"];
    "text/csv" = ["helix.desktop"];
    "image/jpeg" = ["feh.desktop"];
    "image/png" = ["feh.desktop"];
    "x-scheme-handler/https" = ["google-chrome.desktop"];
    "x-scheme-handler/http" = ["google-chrome.desktop"];
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
