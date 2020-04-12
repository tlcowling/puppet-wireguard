define wireguard::peer (
  String $server_endpoint,
  String $server_public_key,
  Array[String] $dns_servers,
  String $private_key,
  String $private_address,
  Numeric $persistent_keepalive = 30,
  String $preshared_key,
  Array[String] $allowed_ips = ["0.0.0.0/0,::0"],
) {

  file { "/etc/wireguard/wg-${name}.conf":
    content => template('wireguard/client_peer.conf.erb'),
  }
}
