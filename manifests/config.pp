# @summary wireguard::config
#
# @param config_path
#   The directory in which Wireguard configurations will live, e.g. /etc/wireguard
#
# @param manage_wireguard_config_directory
#   Should puppet manage the Wireguard configuration directory?  If true, puppet will remove
#   any configurations already present in $config_path
#
class wireguard::config (
  $config_path = $::wireguard::params::config_path,
  $manage_wireguard_config_directory = $::wireguard::params::manage_wireguard_config_directory,
  Hash[String, Hash[String, Any]] $servers = {},
) {
  file { $config_path:
    path    => $config_path,
    mode    => '0750',
    owner   => 'root',
    group   => 'root',
    purge   => $manage_wireguard_config_directory,
    recurse => $manage_wireguard_config_directory,
  }

  $servers.each |$name, $server| {
    wireguard::server { $name:
       endpoint      => $server['endpoint'],
       private_key   => $server['private_key'],
       public_key    => $server['public_key'],
       address       => $server['address'],
       peers         => $server['peers'],
    }
  }
  # exec { "generate keys for ${name}":
  #   cwd     => $config_path,
  #   command => "wg genkey | tee privatekey | wg pubkey > publickey",
  #   path    => ['/usr/bin'],
  # }
}


