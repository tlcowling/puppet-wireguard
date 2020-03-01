class wireguard::install {
  case $::osfamily {
    'Debian','RedHat', 'Amazon': {
      package { 'wireguard':
        ensure => present,
      }
    }
    'Darwin': {
      package { 'wireguard':
        ensure   => present,
        provider => 'brew',
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

}