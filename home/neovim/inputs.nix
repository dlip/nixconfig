# inputs to be added to flake.nix
{...}: {
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
}
