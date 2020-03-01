class wireguard::params {
  $manage_wireguard_config_directory = true
  $manage_masquerade_rules = false
  $save_config = false
  $internet_interface_name = "eth0"

  case $::osfamily {
    'Debian': {
      $config_path = "/etc/wireguard"
    }
    'RedHat', 'Amazon': {
      $config_path = "/etc/wireguard"
    }
    'Darwin': {
      $config_path = "/etc/wireguard"
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}