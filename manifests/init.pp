# @summary Installs and configures Wireguard servers and peers
#

class wireguard (
) inherits ::wireguard::params {

  # validate parameters here

  class { '::wireguard::install': }
  -> Class['::wireguard']
}