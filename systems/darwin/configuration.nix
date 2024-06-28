{pkgs, ...}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages = [
  #   pkgs.vim
  # ];
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    taps = ["espanso/espanso"];
    casks = ["maccy" "clocker" "docker" "flameshot" "espanso" "dbeaver-community" "caffeine"];
    brews = ["switchaudio-osx"];
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  services.yabai.enable = true;
  # services.yabai.enableScriptingAddition = true;
  services.skhd.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
}
