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
# You should generate your own keys: ```wg genkey | tee privatekey | wg pubkey > publickey```
wireguard::config::servers:
  # the key <server1> will create a configuration with the name wg-<name>.conf in the wireguard
  # config directory
  server1: 
    # the endpoint which you will access to connect on Wireguard  
    endpoint: "%{::ipaddress}"
    # the puppet module can optionally put the appropriate masquerade rules into the wireguard config
    manage_masquerade_rules: true
    # the private ip address that the server will have in the VPN
    address: 10.66.67.5/32
    # a wireguard private key (generated using wg genkey) for the server
    private_key: YHqJmZrN54txq61YGbZ9OI4sOKUUkwDglbrkpT0NJGw=
    # the public key derived ffrom the private key
    public_key: BRDTbI8yGycAmYi8jSS0ZaxxF+3E7gCK0LyRcB+kUkI=
    # optionally, DNS servers for your clients
    dns_servers:
      - 8.8.8.8
      - 8.8.4.4
    # peers is a map that defines the peers that the wireguard server will know about, each key of
    # which represents an individual and uniquely named peer
    peers:
      peer1:
        # the private ip address of this client in the VPN
        private_address: 10.66.67.2/32
        # the private_key of the peer
        private_key: sKP4Jlzd/8PbQNPKkrx76bTEMH2VrAVcJW+nNAwHZV0=
        public_key: TxPQs/M47YzchDdNpXVelI31QbCbRAGrR/TOaXE+W0Y=
        # an optional preshared_key 
        preshared_key: 6JjI3Fj2sKMjHS13INI4gJll9y4joXnYBWOxpL7xAEo=
```

Puppet Code

```puppet
# site.pp
lookup('classes', Array[String], 'unique').include
```

The result of this code will generate two configurations on the server - wg-server1.conf, a config for the server and wg-peer1.conf, a config to be copied to the peer that will connect to the server.

In the interests of minimal responsibility, the module will not seek to modify your sysctl settings, though you will need to have `ip_forward=1` set on the server.  The module will display a warning if you do not. 

Additionally this module can optionally generate a postup and postdown command for the server config to configure standard masquerade rules for dealing with hosts using NAT.
