<!-- markdownlint-configure-file { "MD004": { "style": "consistent" } } -->
<!-- markdownlint-disable MD033 -->
#

<p align="center">
 <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://cwd.systems/img/cwd-gate.png">
    <img src="https://cwd.systems/img/cwd-gate.png"  alt="CWD Gate">
  </picture>
<br>
    <strong>CWD Gate AIO Appliance</strong>
</p>

```python
class CWD_GATE():
    
  def __init__(self):
    self.name = "cwd";
    self.username = "cwdsystems";
    self.location = "USA, Canada, Pakistan, KyrgzRepublic, Indonesia";
    self.protonmail = "@cwdsystems";
    self.web = "https://cwd.systems";
    self.languages ="Python,C,PHP,HTML,Bash,Assembly";
  
  def __str__(self):
    return self.name

if __name__ == '__main__':
    me = CWD_GATE()
```


-----

## Pre-installed and configured

Pi-hole comes pre-configured and installed in CWD Gate appliance and is a vital component of privacy package. All you have to do is let your network make use of it. In order to use TOR, you have to configure your client side proxies to use the appliance IP and Port respectively. You can get away by adding plug-ins such as FoxyProxy and overcome the system-wide proxy declarations via Bash in Linux or Internet Settings in Windows.

## Post-install: Make your network take advantage of CWD Gate

Once the installer has been run, you will need to [configure your router to have **DHCP clients use Pi-hole as their DNS server**](https://discourse.pi-hole.net/t/how-do-i-configure-my-devices-to-use-pi-hole-as-their-dns-server/245). This router configuration will ensure that all devices connecting to your network will have content blocked without any further intervention.

If your router does not support setting the DNS server, you can [use Pi-hole's built-in DHCP server](https://discourse.pi-hole.net/t/how-do-i-use-pi-holes-built-in-dhcp-server-and-why-would-i-want-to/3026); be sure to disable DHCP on your router first (if it has that feature available).

As a last resort, you can manually set each device to use CWD Gate as their DNS server.

[TOR](https://torproject.org/) , [Wireguard](https://wireguard.com/) and [Routing](https://opensource.com/business/16/8/introduction-linux-network-routing) come pre-configured and ready to use out of box as well. 

-----

### Alternative support for Pi-hole

If you'd rather not donate (_which is okay!_), there are other ways you can help support us:

- [GitHub Sponsors](https://github.com/sponsors/pi-hole/)
- [Patreon](https://patreon.com/pihole)
- [Hetzner Cloud](https://hetzner.cloud/?ref=7aceisRX3AzA) _affiliate link_
- [Digital Ocean](https://www.digitalocean.com/?refcode=344d234950e1) _affiliate link_
- [Stickermule](https://www.stickermule.com/unlock?ref_id=9127301701&utm_medium=link&utm_source=invite) _earn a $10 credit after your first purchase_
- [Amazon US](https://www.amazon.com/exec/obidos/redirect-home/pihole09-20) _affiliate link_
- Spreading the word about our software and how you have benefited from it

### Contributing via GitHub

We welcome _everyone_ to contribute to issue reports, suggest new features, and create pull requests.

If you have something to add - anything from a typo through to a whole new feature, we're happy to check it out! Just make sure to fill out our template when submitting your request; the questions it asks will help the volunteers quickly understand what you're aiming to achieve.

You'll find that the [install script](https://github.com/pi-hole/pi-hole/blob/master/automated%20install/basic-install.sh) and the [debug script](https://github.com/pi-hole/pi-hole/blob/master/advanced/Scripts/piholeDebug.sh) have an abundance of comments, which will help you better understand how Pi-hole works. They're also a valuable resource to those who want to learn how to write scripts or code a program! We encourage anyone who likes to tinker to read through it and submit a pull request for us to review.

-----

## Breakdown of Pi-hole Features

### [Faster-than-light Engine](https://github.com/pi-hole/ftl)

[FTLDNS](https://github.com/pi-hole/ftl) is a lightweight, purpose-built daemon used to provide statistics needed for the Web Interface, and its API can be easily integrated into your own projects. As the name implies, FTLDNS does this all _very quickly_!

Some of the statistics you can integrate include:

- Total number of domains being blocked
- Total number of DNS queries today
- Total number of ads blocked today
- Percentage of ads blocked
- Unique domains
- Queries forwarded (to your chosen upstream DNS server)
- Queries cached
- Unique clients

Access the API via [`telnet`](https://github.com/pi-hole/FTL), the Web (`admin/api.php`) and Command Line (`pihole -c -j`). You can find out [more details over here](https://discourse.pi-hole.net/t/pi-hole-api/1863).

### The Command-Line Interface

The [pihole](https://docs.pi-hole.net/core/pihole-command/) command has all the functionality necessary to fully administer the Pi-hole, without the need for the Web Interface. It's fast, user-friendly, and auditable by anyone with an understanding of `bash`.

Some notable features include:

- [Whitelisting, Blacklisting, and Regex](https://docs.pi-hole.net/core/pihole-command/#whitelisting-blacklisting-and-regex)
- [Debugging utility](https://docs.pi-hole.net/core/pihole-command/#debugger)
- [Viewing the live log file](https://docs.pi-hole.net/core/pihole-command/#tail)
- [Updating Ad Lists](https://docs.pi-hole.net/core/pihole-command/#gravity)
- [Querying Ad Lists for blocked domains](https://docs.pi-hole.net/core/pihole-command/#query)
- [Enabling and Disabling Pi-hole](https://docs.pi-hole.net/core/pihole-command/#enable-disable)
- ... and _many_ more!

You can read our [Core Feature Breakdown](https://docs.pi-hole.net/core/pihole-command/#pi-hole-core) for more information.

### The Web Interface Dashboard

This [optional dashboard](https://github.com/pi-hole/AdminLTE) allows you to view stats, change settings, and configure your Pi-hole. It's the power of the Command Line Interface, with none of the learning curve!

Some notable features include:

- Mobile-friendly interface
- Password protection
- Detailed graphs and doughnut charts
- Top lists of domains and clients
- A filterable and sortable query log
- Long Term Statistics to view data over user-defined time ranges
- The ability to easily manage and configure Pi-hole features
- ... and all the main features of the Command Line Interface!

There are two ways to [access the dashboard](https://discourse.pi-hole.net/t/how-do-i-access-pi-holes-dashboard-admin-interface/3168):

1. `http://cwd.gate/admin/` (when using FTL as your DNS server)
2. `http://<IP_ADDRESS_OF_YOUR_PI_HOLE>/admin/`

### Port Access Filter

Assuming your LAN network is 192.168.1.x and the appliance is on a public IP address [Firewall Reference](https://www.ibm.com/support/pages/using-iptables-block-specific-ports)

### TOR Router Access

Every network is different and TOR Router needs to listen to specified interface and IP address. Edit the /etc/tor/torrc file and enter the assigned static IP address with port 9050. This assigned IP and port will be used as a TOR proxy on your network proxy settings or browser proxy settings. 

SocksPort 9050 # Default: Bind to localhost:9050 for local connections. <p>
SocksPort 192.168.1.203:9050 # Bind to this address:port too. <p>
SocksPolicy accept 192.168.1.0/24<p>

Once you have made your configuration changes, you can restart the TOR daemon with /etc/init.d/tor restart.

### Configure Wireguard for Public & Interface IP assignments

The file setupVars.conf located in /etc/pivpn/wireguard allows you to assign listening LAN and WAN IP addresses. There are only two entries that you have to modify:

* IPv4addr

`Change this to the LAN IP address with a /24 CIDR. For example, IPv4addr=192.168.2.103/24 `

* pivpnHOST

`This is the public/internet IP address that you have assigned to your WAN port of CWD Blade Appliance. By default WireGuard uses this IP and its default port for all generated users. For example, pivpnHOST=93.143.102.63. The WireGuard profiles will use this public IP Address endpoint to perform all handshakes. `

`::: Connected Clients List :::
Name      Remote IP      Virtual IP                        Bytes Received      Bytes Sent      Last Seen
test      (none)         10.172.10.2,fd11:5ee:bad:c0de::2/128  0B                  0B          (not yet)
::: Disabled clients :::
`
### Default Listening Ports

CWD Gate uses only 6 service ports which are 22 (Inbound SSH), 53 (DNS frontend), 9050 and 9051 (TOR Router) and 4711 (FTL DNS). These ports are only accessible from LAN sid eand not WAN but also depends on how you have configured your firewall and router. This can be confirmed with `ss -tunpl`

### Allowing SSH from LAN only ( Change as per your network specifications )

`iptables -A INPUT -p tcp --dport 22 -s 192.168.2.0/24 -j ACCEPT ` && 
`iptables -A INPUT -p tcp --dport 22 -j DROP`

* Allow Web Access only from LAN

`iptables -A INPUT -p tcp --dport 80 -s 192.168.2.0/24 -j ACCEPT` && 
`iptables -A INPUT -p tcp --dport 80 -j DROP`

* Restrict FTL Access to LAN only

`iptables -A INPUT -p tcp --dport 53 -s 192.168.2.0/24 -j ACCEPT` && 
`iptables -A INPUT -p tcp --dport 53 -j DROP`

