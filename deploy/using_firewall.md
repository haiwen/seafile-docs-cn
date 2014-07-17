# Firewall/NAT settings

A lot of people want to deploy a seafile server in their LAN, and access it from the WAN.

To achieve this, you need:

- A router which supports port forwarding
- Use a dynamic DNS Service
- Modify your seafile server configuration


## Setup the server

First, you should follow the guide on [[Download and Setup Seafile Server]] to setup your Seafile server.

Before you continue, make sure:

- You can visit your seahub website
- You can download/sync a library through your seafile client

## Setup Port Forwarding in Your Router

### Ensure Your Router Supports Port Forwarding

First, ensure your router supports port forwarding.

- Login to the web adminstration page of your router. If you don't know how to do this, you should find the instructions on the manual of the router. If you have no maunal, just google **"XXX router administration page"** where `XXX` is your router's brand.

- Navigate around in the adminstration page, and check if there is a tag which contains a word such as "forward", "advanced". If your router supports it, chances are that you can find the port forwarding related settings there.

### Setup Port Forwarding Rules

Seafile server is composed of several components. You need to configure port forward for all the components listed below.

<table>
<tr>
  <th>component</th>
  <th>default port</th>
</tr>
<tr>
  <td>ccnet</td>
  <td>10001</td>
</tr>
<tr>
  <td>seaf-server</td>
  <td>12001</td>
</tr>
<tr>
  <td>httpserver</td>
  <td>8082</td>
</tr>
<tr>
  <td>seahub</td>
  <td>8000</td>
</tr>
</table>

* You don't need to open port 8000 and 8082 if you deploy Seafile behind Apache/Nginx.
* If you're not using the default ports, you should adjust the table accroding to your own customiztion.

### How to test if your port forwarding is working

After you have set the port forwarding rules on your router, you can check whether it works by:

- Open a command line prompt
- Get your WAN IP. A convenient way to get your WAN ip is to visit `http://who.is`, which would show you your WAN IP.
- Try to connect your seahub server
````
telnet <Your WAN IP> 8000
```

If your port forwarding is working, the command above should succeed. Otherwise, you may get a message saying something like *connection refused* or *connection timeout*.

If your port forwarding is not working, the reasons may be:

- You have configured a wrong port forwarding
- Your router may need a restart
- You network may be down

### Set SERVICE_URL

"SERVICE_URL" in `ccnet.conf` is used to generate the download/upload link for files when you browse files online. Set it using your WAN IP.

```
SERVICE_URL = http://<Your WAN IP>:8000
```

Most routers support NAT loopback. When your access Seafile web from intranet, file download/upload still works even when external IP is used.

## Use a Dynamic DNS Serivce

### Why use a Dynamic DNS(DDNS)  Service?

Having done all the steps above, you should be able to visit your seahub server outside your LAN by your WAN IP. But for most people, the WAN IP address is likey to change regularly by their ISP(Internet Serice Provider), which makes this approach impratical.

You can use a dynamic DNS(DDNS) Service to overcome this problem. By using a dynamic DNS service, you can visit your seahub by domain name (instead of by IP), and the domain name will always be mapped to your WAN IP address, even if it changes regularly.

There are a dozen of dynmaic DNS service providers on the internet. If you don't know what service to choose We recommend using [www.noip.com](http://www.noip.com) since it performs well in our testing.

The detailed process is beyond the scope of this wiki. But basically, you should:

1. Choose a DDNS service provider
2. Register an account on the DDNS service provider's website
3. Download a client from your DDNS service provider to keep your domain name always mapped to your WAN IP

## Modify your seafile configuration

After you have setup your DDNS service, you need to modify the `ccnet.conf`:

```
SERVICE_URL = http://<Your dynamic DNS domain>:8000
```

Restart your seafile server after this.

## Network
By default, you should open 4 ports.

     |
     | Seahub
        | 8000
        |-
        | HttpServer
        | 8082
        |-
        | Ccnet Daemon
        | 10001
        |-
        | Seafile Daemon
        | 12001
        |

If you run Seafile behind Nginx/Apache with HTTPS, you should open ports

     |
     | HTTPS
        | 443
        |-
        | Ccnet Daemon
        | 10001
        |-
        | Seafile Daemon
        | 12001
        |

