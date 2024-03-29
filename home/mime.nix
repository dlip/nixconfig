{...}: let
  associations = {
    "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
    "application/x-wine-extension-ini" = ["nvimterminal.desktop"];
    "application/zip" = ["org.gnome.FileRoller.desktop"];
    "image/jpeg" = ["feh.desktop"];
    "image/png" = ["feh.desktop"];
    "model/stl" = ["fstl.desktop"];
    "inode/directory" = ["thunar.desktop"];
    "text/csv" = ["nvimterminal.desktop"];
    "text/html" = ["google-chrome.desktop"];
    "text/markdown" = ["nvimterminal.desktop"];
    "text/plain" = ["nvimterminal.desktop"];
    "video/x-matroska" = ["mpv.desktop"];
    "x-scheme-handler/msteams" = ["teams.desktop"];
    "x-scheme-handler/slack" = ["slack.desktop"];
    "x-scheme-handler/http" = ["google-chrome.desktop"];
    "x-scheme-handler/https" = ["google-chrome.desktop"];
    "x-scheme-handler/about" = ["google-chrome.desktop"];
    "x-scheme-handler/unknown" = ["google-chrome.desktop"];
    "x-scheme-handler/postman" = ["Postman.desktop"];
    "x-scheme-handler/sidequest" = ["SideQuest.desktop"];
  };
in {
  xdg.desktopEntries.nvimterminal = {
    name = "nvimterminal";
    genericName = "Neovim Text Editor";
    exec = "nvimterminal %u";
  };
  xdg.desktopEntries.helix = {
    name = "helix";
    genericName = "Helix Text Editor";
    exec = "wezterm -e hx %u";
  };
  xdg.desktopEntries.blender-nvidia-offload = {
    name = "Blender Nvidia Offload";
    genericName = "3D modeler";
    exec = "nvidia-offload blender";
  };
  xdg.desktopEntries.superslicer-nvidia-offload = {
    name = "SuperSlicer Nvidia Offload";
    genericName = "3D Printing Software";
    exec = "nvidia-offload superslicer";
  };
  xdg.mimeApps = {
    enable = true;
    associations.added = associations;
    defaultApplications = associations;
  };
}
