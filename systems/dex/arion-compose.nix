{ pkgs, ... }:
{
  project.name = "containers";
  services = {
    homepage.service = {
      image = "ghcr.io/benphelps/homepage:latest";
      ports = [ "3001:3000" ];
      volumes = [ "/mnt/services/homepage/config:/app/config" "/var/run/docker.sock:/var/run/docker.sock" ];
    };
    audiobookshelf.service = {
      image = "ghcr.io/advplyr/audiobookshelf";
      ports = [ "13378:80" ];
      volumes = [
        "/mnt/services/audiobookshelf/config:/config"
        "/mnt/services/audiobookshelf/metadata:/metadata"
        "/media/media/audiobooks:/audiobooks"
        "/media/media/podcasts:/podcasts"
      ];
    };
  };
}
