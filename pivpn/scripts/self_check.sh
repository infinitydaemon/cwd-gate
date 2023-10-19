#!/bin/bash

# Constants
PLAT=$(grep -sEe '^NAME\=' /etc/os-release | sed -E -e "s/NAME\=[\'\"]?([^ ]*).*/\1/")
setupVars="/etc/pivpn/$1/setupVars.conf"

# Functions
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

# Check if setupVars file exists
if [[ ! -f "${setupVars}" ]]; then
  err "::: Missing setup vars file!"
  exit 1
fi

# Source setupVars
source "${setupVars}"

# Variables
VPN="${1}"
VPN_PRETTY_NAME=""
VPN_SERVICE=""
CHECK_STATUS=""

# Determine VPN type
if [[ "${VPN}" == "wireguard" ]]; then
  VPN_PRETTY_NAME="WireGuard"
  VPN_SERVICE="wg-quick@wg0"

  if [[ "${PLAT}" == 'Alpine' ]]; then
    VPN_SERVICE='wg-quick'
  fi
elif [[ "${VPN}" == "openvpn" ]]; then
  VPN_PRETTY_NAME="OpenVPN"
  VPN_SERVICE="openvpn"
fi

# Function to check and attempt to fix IP forwarding
check_ip_forwarding() {
  if [[ "$(< /proc/sys/net/ipv4/ip_forward)" -eq 1 ]]; then
    echo ":: [OK] IP forwarding is enabled"
  else
    read -r -p ":: [ERR] IP forwarding is not enabled, attempt fix now? [Y/n] " REPLY
    if [[ "${REPLY}" =~ ^[Yy]$ ]] || [[ -z "${REPLY}" ]]; then
      sed -i '/net.ipv4.ip_forward=1/s/^#//g' /etc/sysctl.conf
      sysctl -p
      echo "Done"
    fi
  fi
}

# Function to check and attempt to set up iptables rule
check_iptables_rule() {
  local chain_type="$1"
  local rule_desc="$2"
  local iptables_args=()

  if [[ "${chain_type}" == "nat" ]]; then
    iptables_args=("-t" "nat" "-C" "POSTROUTING" "-s" "${pivpnNET}/${subnetClass}" "-o" "${IPv4dev}" "-j" "MASQUERADE" "-m" "comment" "--comment" "${VPN}-nat-rule")
  elif [[ "${chain_type}" == "input" ]]; then
    iptables_args=("-C" "INPUT" "-i" "${IPv4dev}" "-p" "${pivpnPROTO}" "--dport" "${pivpnPORT}" "-j" "ACCEPT" "-m" "comment" "--comment" "${VPN}-input-rule")
  elif [[ "${chain_type}" == "forward" ]]; then
    iptables_args=("-C" "FORWARD" "-s" "${pivpnNET}/${subnetClass}" "-i" "${pivpnDEV}" "-o" "${IPv4dev}" "-j" "ACCEPT" "-m" "comment" "--comment" "${VPN}-forward-rule")
  fi

  if iptables "${iptables_args[@]}" &> /dev/null; then
    echo ":: [OK] Iptables ${rule_desc} rule set"
  else
    read -r -p ":: [ERR] Iptables ${rule_desc} rule is not set, attempt fix now? [Y/n] " REPLY
    if [[ "${REPLY}" =~ ^[Yy]$ ]] || [[ -z "${REPLY}" ]]; then
      iptables "${iptables_args[@]}"
      iptables-save > /etc/iptables/rules.v4
      echo "Done"
    fi
  fi
}

# Check IP forwarding
check_ip_forwarding

# Check iptables rules
check_iptables_rule "nat" "MASQUERADE"
check_iptables_rule "input" "INPUT"
check_iptables_rule "forward" "FORWARD"

# Check VPN service status and enable/start if needed
if [[ "${PLAT}" == 'Alpine' ]]; then
  CHECK_STATUS=$(rc-service "${VPN_SERVICE}" status | sed -E -e 's/.*status\: (.*)/\1/')
else
  CHECK_STATUS=$(systemctl is-active -q "${VPN_SERVICE}" && echo "started" || echo "stopped")
fi

if [[ "${CHECK_STATUS}" == 'started' ]]; then
  echo ":: [OK] ${VPN_PRETTY_NAME} is running"
else
  read -r -p ":: [ERR] ${VPN_PRETTY_NAME} is not running, try to start now? [Y/n] " REPLY
  if [[ "${REPLY}" =~ ^[Yy]$ ]] || [[ -z "${REPLY}" ]]; then
    if [[ "${PLAT}" == 'Alpine' ]]; then
      rc-service -s "${VPN_SERVICE}" restart
      rc-service -N "${VPN_SERVICE}" start
    else
      systemctl start "${VPN_SERVICE}"
    fi
    echo "Done"
  fi
fi

# Enable VPN service on boot if not already enabled
if [[ "${PLAT}" == 'Alpine' ]]; then
  if ! rc-update show default | grep -sEe "\s*${VPN_SERVICE} .*" &> /dev/null; then
    read -r -p ":: [ERR] ${VPN_PRETTY_NAME} is not enabled, try to enable now? [Y/n] " REPLY
    if [[ "${REPLY}" =~ ^[Yy]$ ]] || [[ -z "${REPLY}" ]]; then
      rc-update add "${VPN_SERVICE}" default
      echo "Done"
    fi
  else
    echo -n ":: [OK] ${VPN_PRETTY_NAME} is enabled "
    echo "(it will automatically start on reboot)"
  fi
else
  if ! systemctl is-enabled -q "${VPN_SERVICE}"; then
    read -r -p ":: [ERR] ${VPN_PRETTY_NAME} is not enabled, try to enable now? [Y/n] " REPLY
    if [[ "${REPLY}" =~ ^[Yy]$ ]] || [[ -z "${REPLY}" ]]; then
      systemctl enable "${VPN_SERVICE}"
      echo "Done"
    fi
  else
    echo -n ":: [OK] ${VPN_PRETTY_NAME} is enabled "
    echo "(it will automatically start on reboot)"
  fi
fi

# Check if VPN is listening on the specified port
if netstat -antu | grep -wqE "${pivpnPROTO}.*${pivpnPORT}"; then
  echo -n ":: [OK] ${VPN_PRETTY_NAME} is listening "
  echo "on port ${pivpnPORT}/${pivpnPROTO}"
else
  read -r -p ":: [ERR] ${VPN_PRETTY_NAME} is not listening, try to restart now? [Y/n] " REPLY
  if [[ "${REPLY}" =~ ^[Yy]$ ]] || [[ -z "${REPLY}" ]]; then
    if [[ "${PLAT}" == 'Alpine' ]]; then
      rc-service -s "${VPN_SERVICE}" restart
      rc-service -N "${VPN_SERVICE}" start
    else
      systemctl restart "${VPN_SERVICE}"
    fi
    echo "Done"
  fi
fi

if [[ "${ERR}" -eq 1 ]]; then
  echo -e "[INFO] Run \e[1mpivpn -d\e[0m again to see if we detect issues"
fi
