{
  # Public key of the server (not a file path).
  publicKey = "+YVMX+HXcyFsfxGWdWC+WdI6nUMkyMdtxsohVDJavlQ=";

  # Forward all the traffic via VPN.
  allowedIPs = ["10.10.0.0/24"];
  # Or forward only particular subnets
  #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

  # Set this to the server IP and port.
  endpoint = "lips-home.duckdns.org:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

  # Send keepalives every 25 seconds. Important to keep NAT tables alive.
  persistentKeepalive = 25;
}
