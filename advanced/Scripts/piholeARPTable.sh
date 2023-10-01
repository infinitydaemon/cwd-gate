#!/usr/bin/env bash
# shellcheck disable=SC1090

# Pi-hole: A black hole for Internet advertisements
# (c) 2019 Pi-hole, LLC (https://pi-hole.net)
# Network-wide ad blocking via your own hardware.
#
# ARP table interaction
#
# This file is copyright under the latest version of the EUPL.
# Please see LICENSE file for your rights under this license.

COL_TABLE="/opt/pihole/COL_TABLE"

if [[ -f $COL_TABLE ]]; then
    source "$COL_TABLE"
fi

# Determine database location
FTL_CONF="/etc/pihole/pihole-FTL.conf"
DBFILE=$(grep -Eo '^\s*DBFILE\s*=\s*\S+' "$FTL_CONF" | cut -d= -f2)

# Use standard path if DBFILE is empty
DBFILE=${DBFILE:-"/etc/pihole/pihole-FTL.db"}

flushARP() {
    local output
    if [[ ${args[1]} != "quiet" ]]; then
        echo -ne "  ${INFO} Flushing network table ..."
    fi

    if ! output=$(pihole-FTL sqlite3 "$DBFILE" "DELETE FROM network_addresses" 2>&1); then
        echo -e "${OVER}  ${CROSS} Failed to truncate network_addresses table"
        echo "  Database location: $DBFILE"
        echo "  Output: $output"
        return 1
    fi

    if ! output=$(pihole-FTL sqlite3 "$DBFILE" "DELETE FROM network" 2>&1); then
        echo -e "${OVER}  ${CROSS} Failed to truncate network table"
        echo "  Database location: $DBFILE"
        echo "  Output: $output"
        return 1
    fi

    if [[ ${args[1]} != "quiet" ]]; then
        echo -e "${OVER}  ${TICK} Flushed network table"
    fi
}

args=("$@")

case "${args[0]}" in
    "arpflush") flushARP ;;
esac
