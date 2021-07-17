{ pkgs, ... }: {
  home.file = {
    ".config/espanso/default.yml" = {
      source = ./espanso.yaml;
    };
  };
}
