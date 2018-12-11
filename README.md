# DnsEx

This is a quickly cobbled-together DNS server (using Elixir, though that's
incidental). The point of the exercise is that this DNS server is deliberately
slow. It can therefore be used for testing.

Specifically, I'm using it at [Electric Imp](https://www.electricimp.com/) to
prove that asynchronous DNS resolution is required for agent-side bindings.

## Building it

    mix

## Running it

    iex -S mix

## Using it

    dig @localhost -p 10053 delay-1000.ttl-15.foo.dns_ex

## Configuring dnsmasq

For Ubuntu 16.04, create a file `/etc/NetworkManager/dnsmasq.d/dns_ex` containing:

    server=/dns_ex/127.0.0.1#10053

Restart the network-manager service:

    sudo service network-manager restart

And now you can just:

    ping delay-1000.ttl-15.foo.dns_ex
