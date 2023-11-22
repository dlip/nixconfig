{
  pkgs,
  config,
  ...
}: let
  emacs = pkgs.unstable.emacs29.override {
    withNativeCompilation = true;
    withTreeSitter = true;
  };
in {
  # home.file = {
  #   ".emacs.d" = {
  #     source = ./config;
  #     recursive = true;
  #   };
  # };

  home.file = {
    "${config.xdg.configHome}/emacs".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/emacs/config";
  };

  home.packages = [
    ((pkgs.unstable.emacsPackagesFor emacs).emacsWithPackages (epkgs: (
      with epkgs; [
        catppuccin-theme
        counsel
        direnv
        evil
        evil-collection
        evil-tutor
        format-all
        general
        ivy
        lsp-mode
        nix-ts-mode
        projectile
        swiper
        treesit-grammars.with-all-grammars
        treesit-auto
        vterm
        vterm-toggle
        which-key
      ]
    )))
  ];
  # services.emacs = {
  #   enable = true;
  #   # temporarily disable to work around a desktop file collision issue
  #   # https://github.com/nix-community/emacs-overlay/issues/58
  #   # client.enable = true;
  # };

  # home.packages = with pkgs; [
  #   aspell
  #   aspellDicts.en
  #   aspellDicts.en-computers
  # ];

  # programs.emacs = {
  #   enable = true;
  #   package = pkgs.unstable.emacs29.override {
  #     withNativeCompilation = true;
  #     withTreeSitter = true;
  #   };
  #   extraPackages = epkgs: (with epkgs; [
  # ace-window
  # all-the-icons
  # avy
  # avy-zap
  # calibredb
  # command-log-mode
  # company
  # company-go
  # company-prescient
  # consult
  # crux
  # dap-mode
  # doom-modeline
  # doom-themes
  # duplicate-thing
  # embark
  # embark-consult
  # expand-region
  # flycheck
  # # yaml taking ages to compile
  # # forge
  # format-all
  # general
  # go-mode
  # hydra
  # iflipb
  # init-loader
  # lsp-mode
  # lsp-treemacs
  # lsp-ui
  # magit
  # marginalia
  # multiple-cursors
  # nix-mode
  # nov
  # orderless
  # org
  # org-bullets
  # org-drill
  # org-noter
  # org-roam
  # org-tree-slide
  # org-web-tools
  # pdf-tools
  # persp-mode
  # persp-mode-projectile-bridge
  # projectile
  # rainbow-delimiters
  # ripgrep
  # selectrum
  # selectrum-prescient
  # super-save
  # treemacs
  # treemacs
  # treemacs-all-the-icons
  # treemacs-icons-dired
  # treemacs-magit
  # treemacs-projectile
  # typescript-mode
  # use-package
  # visual-fill-column
  # visual-regexp
  # visual-regexp-steroids
  # vterm
  # web-mode
  # wgrep
  # which-key
  # yaml-mode
  # git-timemachine
  # ]);
  # };
}
