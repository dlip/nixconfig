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
        all-the-icons
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
        company
        company-prescient
        company-go
        go-mode
        consult
        embark
        embark-consult
        marginalia
        which-key
        persp-mode
        persp-mode-projectile-bridge
        iflipb
        org-journal
        org-web-tools
        org-bullets
        org-tree-slide
        visual-fill-column
        rainbow-delimiters
        typescript-mode
        web-mode
        vterm
        flycheck
        use-package
        lsp-ui
        treemacs
        lsp-treemacs
        dap-mode
        ripgrep
        wgrep
        treemacs
        treemacs-projectile
        treemacs-magit
        treemacs-icons-dired
        treemacs-all-the-icons
        yaml-mode
        nov
        org-noter
        org-drill
        general
        hydra
        multiple-cursors
        expand-region
        avy
        duplicate-thing
        ace-window
      ]));
  };
}
