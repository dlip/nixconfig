{...}: {
  home.sessionVariables = {
    GOPATH = "$HOME/go";
    PATH = "$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$HOME/.cargo/bin:/etc/profiles/per-user/$USER/bin:$PATH";
    EDITOR = "hx";
    LANG = "en_AU.UTF-8";
    LC_ALL = "en_AU.UTF-8";
  };
}
