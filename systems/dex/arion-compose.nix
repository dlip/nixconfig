{ pkgs, ... }:
{
  project.name = "containers";
  services = {
    homepage.service = {
      image = "ghcr.io/benphelps/homepage:latest";
      ports = [ "3001:3000" ];
      volumes = [ "/tmp/homepage/config:/app/config" "/var/run/docker.sock:/var/run/docker.sock" ];
    };
  };
}
