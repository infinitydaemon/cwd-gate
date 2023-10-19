#!/bin/bash -e

# Get the first non-loopback interface
interface=$(ip -o link | awk -F': ' '!/lo/{print $2; exit}')

# Get IP address and gateway
ipaddress=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
gateway=$(ip route show default | awk '/default/ {print $3}')

# Set hostname
hostname="pivpn.test"
sudo hostnamectl set-hostname "${hostname}"

# Error handling function
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
  exit 1
}

# Common configuration
common() {
  sed -i "s/INTERFACE/$interface/g" "$vpnconfig"
  sed -i "s|IPADDRESS|$ipaddress|g" "$vpnconfig"
  sed -i "s/GATEWAY/$gateway/g" "$vpnconfig"
}

# OpenVPN configuration
openvpn() {
  vpnconfig="ciscripts/ci_openvpn.conf"
  twofour=1
  common
  sed -i "s/2POINT4/$twofour/g" "$vpnconfig"
  cat "$vpnconfig"
}

# WireGuard configuration
wireguard() {
  vpnconfig="ciscripts/ci_wireguard.conf"
  common
  cat "$vpnconfig"
}

# Main logic
if [[ "$#" -lt 1 ]]; then
  err "Specify a VPN protocol to prepare (-o for OpenVPN, -w for WireGuard)"
fi

# Process arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -o | --openvpn)
      openvpn
      ;;
    -w | --wireguard)
      wireguard
      ;;
    *)
      err "Unknown VPN protocol. Use -o for OpenVPN or -w for WireGuard."
      ;;
  esac
  shift
done

exit 0
