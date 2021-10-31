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
    inputs: {
    overlay = final: prev: {
      myVimPlugins = builtins.listToAttrs (map (input: {
         name = input;
         value = (final.vimUtils.buildVimPluginFrom2Nix {
            name = input;
            src = (builtins.getAttr input inputs);
        });
      })
         (builtins.attrNames inputs));
    };
  };
}
