define wireguard::server (
  Boolean $save_config = $::wireguard::params::save_config,
  Boolean $manage_masquerade_rules = $::wireguard::params::manage_masquerade_rules,
  String $internet_interface_name = $::wireguard::params::internet_interface_name,
  String $private_key,
  String $public_key,
  String $address,
  Hash[String, Hash[String, Any]] $peers,
  Array[String] $dns_servers = ["1.1.1.1", "1.0.0.1"],
  Integer[0, 65535] $listen_port = 53,
  String $endpoint,
) {

  concat { "/etc/wireguard/wg-${name}.conf":
    ensure => present,
    mode   => '0600',
  }

  concat::fragment { "/etc/wireguard/wg-${name}.conf-interface":
    target  => "/etc/wireguard/wg-${name}.conf",
    content => template('wireguard/interface.conf.erb'),
    order   => '01'
  }

  $peers.each |$peer_name, $peer| {
    $preshared_key = $peer['preshared_key']
    $client_public_key = $peer['public_key']

    concat::fragment { "/etc/wireguard/wg-${name}.conf-$peer_name":
      target  => "/etc/wireguard/wg-${name}.conf",
      content => template('wireguard/server_peer.conf.erb'),
    }

    wireguard::peer { $peer_name:
      server_endpoint=> "${endpoint}:${listen_port}",
      server_public_key=> $public_key,
      dns_servers => $dns_servers,
      private_address=> $peer['private_address'],
      persistent_keepalive=> $peer['persistent_keepalive'],
      preshared_key=> $preshared_key,
      private_key=> $peer['private_key'],
    }
  }
}
