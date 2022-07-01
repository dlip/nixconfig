{
  inputs = {
    # asyncrun-vim = {
    #   url = "github:skywind3000/asyncrun.vim";
    #   flake = false;
    # };
    # autosave-nvim = {
    #   url = "github:Pocco81/AutoSave.nvim";
    #   flake = false;
    # };
    # cmp_luasnip = {
    #   url = "github:saadparwaiz1/cmp_luasnip";
    #   flake = false;
    # };
    # fire-nvim = {
    #   url = "github:glacambre/firenvim";
    #   flake = false;
    # };
    format-nvim = {
      url = "github:lukas-reineke/format.nvim";
      flake = false;
    };
    # hop-nvim = {
    #   url = "github:phaazon/hop.nvim";
    #   flake = false;
    # };
    kmonad-vim = {
      url = "github:kmonad/kmonad-vim";
      flake = false;
    };
    # luasnip = {
    #   url = "github:L3MON4D3/LuaSnip";
    #   flake = false;
    # };
    # lspkind-nvim = {
    #   url = "github:onsails/lspkind-nvim";
    #   flake = false;
    # };
    # neogit = {
    #   url = "github:TimUntersberger/neogit";
    #   flake = false;
    # };
    # nnn-nvim = {
    #   url = "github:luukvbaal/nnn.nvim";
    #   flake = false;
    # };
    # nui-nvim = {
    #   url = "github:MunifTanjim/nui.nvim";
    #   flake = false;
    # };
    neotest-jest = {
      url = "github:haydenmeade/neotest-jest";
      flake = false;
    };
    neotest-plenary = {
      url = "github:nvim-neotest/neotest-plenary";
      flake = false;
    };
    neotest-vim-test = {
      url = "github:nvim-neotest/neotest-vim-test";
      flake = false;
    };
    nvim-neotest = {
      url = "github:nvim-neotest/neotest";
      flake = false;
    };
    fix-cursor-hold-nvim = {
      url = "github:antoinemadec/FixCursorHold.nvim";
      flake = false;
    };
    # nvim-dap-go = {
    #   url = "github:leoluz/nvim-dap-go";
    #   flake = false;
    # };
    # octo-nvim = {
    #   url = "github:pwntester/octo.nvim";
    #   flake = false;
    # };
    # package-info-nvim = {
    #   url = "github:vuki656/package-info.nvim";
    #   flake = false;
    # };
    # rest-nvim = {
    #   url = "github:NTBBloodbath/rest.nvim";
    #   flake = false;
    # };
    telescope-nvim = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    vim-test = {
      url = "github:excalios/vim-test";
      flake = false;
    };
    # vim-delve = {
    #   url = "github:sebdah/vim-delve";
    #   flake = false;
    # };
    # which-key-nvim = {
    #   url = "github:folke/which-key.nvim";
    #   flake = false;
    # };
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
