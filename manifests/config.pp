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
  # Array[Wireguard::Server] $servers,
  $servers,
) {
  file { $config_path:
    path    => $config_path,
    mode    => '0750',
    owner   => 'root',
    group   => 'root',
    purge   => $manage_wireguard_config_directory,
    recurse => $manage_wireguard_config_directory,
  }
  create_resources(wireguard::server, $servers)
  # $servers.each |$server| {
  #   wireguard::server { $server['description']:
  #     description => $server['description'],
  #     private_key =>
  #   }
  # }
  # exec { "generate keys for ${name}":
  #   cwd     => $config_path,
  #   command => "wg genkey | tee privatekey | wg pubkey > publickey",
  #   path    => ['/usr/bin'],
  # }
}


