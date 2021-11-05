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
    nnn-nvim = {
      url = "github:luukvbaal/nnn.nvim";
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
      overlay = self: super: {
        vimPlugins = super.vimPlugins // builtins.listToAttrs (map
          (input: {
            name = input;
            value = (self.vimUtils.buildVimPluginFrom2Nix {
              name = input;
              src = (builtins.getAttr input inputs);
            });
          })
          (builtins.attrNames (self.lib.filterAttrs (n: v: n != "self") inputs)));
      };
    };
}
