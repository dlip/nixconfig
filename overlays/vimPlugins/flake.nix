{
  inputs = {
    asyncrun-vim = {
      url = "github:skywind3000/asyncrun.vim";
      flake = false;
    };
    autosave-nvim = {
      url = "github:Pocco81/AutoSave.nvim";
      flake = false;
    };
    fire-nvim = {
      url = "github:glacambre/firenvim";
      flake = false;
    };
    lspkind-nvim = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    nnn-nvim = {
      url = "github:luukvbaal/nnn.nvim";
      flake = false;
    };
    nui-nvim = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    nvim-dap-go = {
      url = "github:leoluz/nvim-dap-go";
      flake = false;
    };
    package-info-nvim = {
      url = "github:vuki656/package-info.nvim";
      flake = false;
    };
    rest-nvim = {
      url = "github:NTBBloodbath/rest.nvim";
      flake = false;
    };
    telescope-nvim = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    vim-delve = {
      url = "github:sebdah/vim-delve";
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
