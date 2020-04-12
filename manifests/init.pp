# @summary Installs and configures Wireguard servers and peers
#
class wireguard (
) inherits ::wireguard::params {

  # validate parameters here
  if $ip_forward == "0" {
    warning('For wireguard to function, ip_forwarding needs to be enabled')
  }

  class { '::wireguard::install': }
  ~> class { '::wireguard::config': }
  -> Class['::wireguard']
}
