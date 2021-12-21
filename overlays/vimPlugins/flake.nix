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
    cmp_luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    fire-nvim = {
      url = "github:glacambre/firenvim";
      flake = false;
    };
    format-nvim = {
      url = "github:lukas-reineke/format.nvim";
      flake = false;
    };
    neogit = {
      url = "github:TimUntersberger/neogit";
      flake = false;
    };
    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
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
    octo-nvim = {
      url = "github:pwntester/octo.nvim";
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
      overlay = final: prev: {
        vimPlugins = prev.vimPlugins // builtins.listToAttrs (map
          (input: {
            name = input;
            value = (final.vimUtils.buildVimPluginFrom2Nix {
              name = input;
              src = (builtins.getAttr input inputs);
            });
          })
          (builtins.attrNames (final.lib.filterAttrs (n: v: n != "self") inputs)));
      };
    };
}
