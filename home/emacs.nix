{ pkgs, ... }: {

  home.file = {
    ".emacs.d" = {
      source = ./emacs;
      recursive = true;
    };
  };

  services.emacs = {
    enable = true;
    # temporarily disable to work around a desktop file collision issue
    # https://github.com/nix-community/emacs-overlay/issues/58
    # client.enable = true;
  };

  home.packages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.en-computers
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacsGcc;
    extraPackages = (epkgs:
      (with epkgs; [
        all-the-icons-ivy
        command-log-mode
        doom-modeline
        doom-themes
        format-all
        lsp-mode
        magit
        nix-mode
        org
        org-roam
        projectile
        selectrum
        selectrum-prescient
        orderless
        consult
        embark
        marginalia
        which-key
      ]));
  };
}
