define wireguard::server (
  Boolean $save_config = $::wireguard::params::save_config,
  Boolean $manage_masquerade_rules = $::wireguard::params::manage_masquerade_rules,
  String $internet_interface_name = $::wireguard::params::internet_interface_name,
  String $private_key,
  String $public_key,
  String $address,
  Array $peers,
  Array[String] $dns_servers = ["1.1.1.1", "1.0.0.1"],
  Integer[0, 65535] $listen_port = 0,
  Optional[String] $notify_email_address = "",
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

  $peers.each |$peer| {
    $public_key = $peer['public_key']
    $allowed_ips = $peer['allowed_ips']
    $endpoint = $peer['endpoint']
    $persistent_keepalive = $peer['persistent_keepalive']
    concat::fragment { "/etc/wireguard/wg-${name}.conf-$peer":
      target  => "/etc/wireguard/wg-${name}.conf",
      content => template('wireguard/peer.conf.erb'),
    }
  }

  if $notify_email_address != "" {
    exec { "email updated config to ${notify_email_address} for wg-${name}":
      subscribe   => Concat["/etc/wireguard/wg-${name}.conf"],
      command     => "cat /tmp/mail-${name}.txt | mail -s 'Updated VPN Configuration' ${notify_email_address} -a /etc/wireguard/wg-${name}.conf",
      path        => ['/usr/bin','/bin'],
      logoutput   => true,
      refreshonly => true,
      require     => File["/tmp/mail-${name}.txt"],
    }
  }
}
