class wireguard::install {
  package { 'wireguard-tools':
    ensure => present,
  }
}