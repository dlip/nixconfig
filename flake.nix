{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    envy-sh = {
      url = "github:dlip/envy.sh";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    actual-server = {
      url = "github:actualbudget/actual-server";
      flake = false;
    };
    emoji-menu = {
      url = "github:jchook/emoji-menu";
      flake = false;
    };
    keyd = {
      url = "github:rvaiya/keyd";
      flake = false;
    };
    power-menu = {
      url = "github:jluttine/rofi-power-menu";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    openvpn-aws = {
      url = "github:abhibansal530/dotfiles";
      flake = false;
    };
    repo-nnn = {
      url = "github:jarun/nnn";
      flake = false;
    };
    repo-awesome-wm-widgets = {
      url = "github:streetturtle/awesome-wm-widgets";
      flake = false;
    };
    repo-arc-icon-theme = {
      url = "github:horst3180/arc-icon-theme";
      flake = false;
    };
    repo-json-lua = {
      url = "github:rxi/json.lua";
      flake = false;
    };
    vscodeNodeDebug2 = {
      url = "github:microsoft/vscode-node-debug2";
      flake = false;
    };
    vimplugin-auto-save-nvim = {
      url = "github:pocco81/auto-save.nvim";
      flake = false;
    };
    vimplugin-leap-nvim = {
      url = "github:ggandor/leap.nvim";
      flake = false;
    };
    vimplugin-lsp-format-nvim = {
      url = "github:lukas-reineke/lsp-format.nvim";
      flake = false;
    };
    vimplugin-kmonad-vim = {
      url = "github:kmonad/kmonad-vim";
      flake = false;
    };
    vimplugin-neotest-jest = {
      url = "github:haydenmeade/neotest-jest";
      flake = false;
    };
    vimplugin-neotest-plenary = {
      url = "github:nvim-neotest/neotest-plenary";
      flake = false;
    };
    vimplugin-neotest-vim-test = {
      url = "github:nvim-neotest/neotest-vim-test";
      flake = false;
    };
    vimplugin-nvim-neotest = {
      url = "github:nvim-neotest/neotest";
      flake = false;
    };
    vimplugin-fix-cursor-hold-nvim = {
      url = "github:antoinemadec/FixCursorHold.nvim";
      flake = false;
    };
    vimplugin-nvim-dap-ui = {
      url = "github:rcarriga/nvim-dap-ui";
      flake = false;
    };
    vimplugin-telescope-nvim = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    vimplugin-vim-test = {
      url = "github:excalios/vim-test";
      flake = false;
    };
  };

  outputs = inputs: (import ./outputs.nix inputs);
}
