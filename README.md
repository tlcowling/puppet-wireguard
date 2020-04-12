# puppet-wireguard

A Puppet module to install and configure Wireguard and setup clients

## Example
Hiera Config

```yaml
# common.yaml
classes:
  - wireguard

# ***WARNING***
# Whilst the keys in this configuration are valid...
# DO NOT USE THEM FOR YOUR CONFIGURATION
wireguard::config::servers:
  server1:
    endpoint: "%{::ipaddress}"
    manage_masquerade_rules: true
    address: 10.66.67.5/32
    private_key: YHqJmZrN54txq61YGbZ9OI4sOKUUkwDglbrkpT0NJGw=
    public_key: BRDTbI8yGycAmYi8jSS0ZaxxF+3E7gCK0LyRcB+kUkI=
    dns_servers:
      - 8.8.8.8
      - 8.8.4.4
    peers:
      peer1:
        private_address: 10.66.67.2/32
        private_key: sKP4Jlzd/8PbQNPKkrx76bTEMH2VrAVcJW+nNAwHZV0=
        public_key: TxPQs/M47YzchDdNpXVelI31QbCbRAGrR/TOaXE+W0Y=
        preshared_key: 6JjI3Fj2sKMjHS13INI4gJll9y4joXnYBWOxpL7xAEo=
```

Puppet Code

```puppet
# site.pp
lookup('classes', Array[String], 'unique').include
```
