{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/70824bb5c790b820b189f62f643f795b1d2ade2e";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dap-adapters = {
      url = "./overlays/dapAdapters";
    };
    repos = {
      url = "./overlays/repos";
    };
    personal = {
      url = "./overlays/personal";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
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
    vimplugin-auto-save-nvim = {
      url = "github:pocco81/auto-save.nvim";
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
