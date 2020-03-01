define wireguard::peer (
  String $public_key,
  String $endpoint,
  String $persistent_keepalive,
  Array[String] $allowed_ips = ["0.0.0.0/0,::0"],
) {

}
