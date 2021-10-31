{
  inputs = {
    autosave-nvim = {
      url = "github:Pocco81/AutoSave.nvim";
      flake = false;
    };
    lspkind-nvim = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    fire-nvim = {
      url = "github:glacambre/firenvim";
      flake = false;
    };
    vim-delve = {
      url = "github:sebdah/vim-delve";
      flake = false;
    };
    nvim-dap-go = {
      url = "github:leoluz/nvim-dap-go";
      flake = false;
    };
    rest-nvim = {
      url = "github:NTBBloodbath/rest.nvim";
      flake = false;
    };
  };

  outputs =
    { self
    , autosave-nvim
    , lspkind-nvim
    , fire-nvim
    , vim-delve
    , nvim-dap-go
    , rest-nvim
    }: {
    overlay = final: prev: {
      myVimPlugins = {
        autosave-nvim = (final.vimUtils.buildVimPluginFrom2Nix {
            name = "autosave-nvim";
            src = autosave-nvim;
            });
        lspkind-nvim = (final.vimUtils.buildVimPluginFrom2Nix {
            name = "lspkind-nvim";
            src = lspkind-nvim;
            });
        fire-nvim = (final.vimUtils.buildVimPluginFrom2Nix {
            name = "fire-nvim";
            src = fire-nvim;
            });
        vim-delve = (final.vimUtils.buildVimPluginFrom2Nix {
            name = "vim-delve";
            src = vim-delve;
            });
        nvim-dap-go = (final.vimUtils.buildVimPluginFrom2Nix {
            name = "nvim-dap-go";
            src = nvim-dap-go;
            });
        rest-nvim = (final.vimUtils.buildVimPluginFrom2Nix {
            name = "rest-nvim";
            src = rest-nvim;
            });
      };
    };
  };
}
