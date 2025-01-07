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

# Source the color table if it exists
if [[ -f "$COL_TABLE" ]]; then
    source "$COL_TABLE"
fi

# Determine database location
FTL_CONF="/etc/pihole/pihole-FTL.conf"
DBFILE=$(grep -Eo '^\s*DBFILE\s*=\s*[^#]+' "$FTL_CONF" | cut -d= -f2 | xargs)

# Use standard path if DBFILE is empty or unset
DBFILE="${DBFILE:-/etc/pihole/pihole-FTL.db}"

flushARP() {
    local output

    if [[ "${args[1]}" != "quiet" ]]; then
        echo -ne "  ${INFO} Flushing network table ..."
    fi

    # Delete from network_addresses table
    if ! output=$(pihole-FTL sqlite3 "$DBFILE" "DELETE FROM network_addresses" 2>&1); then
        echo -e "${OVER}  ${CROSS} Failed to truncate network_addresses table"
        echo "  Database location: $DBFILE"
        echo "  Output: $output"
        return 1
    fi

    # Delete from network table
    if ! output=$(pihole-FTL sqlite3 "$DBFILE" "DELETE FROM network" 2>&1); then
        echo -e "${OVER}  ${CROSS} Failed to truncate network table"
        echo "  Database location: $DBFILE"
        echo "  Output: $output"
        return 1
    fi

    # Success message
    if [[ "${args[1]}" != "quiet" ]]; then
        echo -e "${OVER}  ${TICK} Flushed network table"
    fi
}

# Parse arguments and execute commands
args=("$@")

case "${args[0]}" in
    "arpflush")
        flushARP
        ;;
    *)
        echo "Usage: $0 arpflush [quiet]"
        exit 1
        ;;
esac
