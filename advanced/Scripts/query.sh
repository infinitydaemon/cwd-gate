#!/usr/bin/env bash
# shellcheck disable=SC1090

# Pi-hole: A black hole for Internet advertisements
# (c) 2018 Pi-hole, LLC (https://pi-hole.net)
# Network-wide ad blocking via your own hardware.
#
# Query Domain Lists
#
# This file is copyright under the latest version of the EUPL.
# Please see LICENSE file for your rights under this license.

# Globals
piholeDir="/etc/pihole"
GRAVITYDB="${piholeDir}/gravity.db"
options="$*"
all=""
exact=""
matchType="match"

# Load configuration
pihole_FTL="${piholeDir}/pihole-FTL.conf"
if [[ -f "${pihole_FTL}" ]]; then
    source "${pihole_FTL}"
fi

# Set gravity database path after sourcing configuration
gravityDBfile="${GRAVITYDB}"

# Load color table
colfile="/opt/pihole/COL_TABLE"
if [[ -f "${colfile}" ]]; then
    source "${colfile}"
fi

# Function to scan a list of files for matching strings
scanList() {
    local domain="${1}" esc_domain="${1//./\\.}" lists="${2}" list_type="${3:-}"
    cd "$piholeDir" || exit 1

    # Prevent grep -i from matching slowly
    export LC_CTYPE=C

    case "${list_type}" in
        "exact")
            grep -i -E -l "(^|(?<!#)\\s)${esc_domain}($|\\s|#)" ${lists} /dev/null 2>/dev/null
            ;;
        "regex")
            for list in ${lists}; do
                if [[ "${domain}" =~ ${list} ]]; then
                    printf "%b\n" "${list}"
                fi
            done
            ;;
        *)
            grep -i "${esc_domain}" ${lists} /dev/null 2>/dev/null
            ;;
    esac
}

# Show usage information
if [[ "${options}" == "-h" ]] || [[ "${options}" == "--help" ]]; then
    echo "Usage: pihole -q [option] <domain>
Example: 'pihole -q -exact domain.com'
Query the adlists for a specified domain

Options:
  -exact              Search the adlists for exact domain matches
  -all                Return all query matches within the adlists
  -h, --help          Show this help dialog"
    exit 0
fi

# Handle valid options
[[ "${options}" == *"-all"* ]] && all=true
if [[ "${options}" == *"-exact"* ]]; then
    exact="exact"
    matchType="exact ${matchType}"
fi

# Strip valid options, leaving only the domain and invalid options
options=$(sed -E 's/ ?-(adlists?|all|exact) ?//g' <<< "${options}")

# Handle domain input
case "${options}" in
    "")
        echo "No domain specified. Try 'pihole -q --help' for more information."
        exit 1
        ;;
    *" "*)
        echo "Unknown query option specified. Try 'pihole -q --help' for more information."
        exit 1
        ;;
    *[![:ascii:]]*)
        domainQuery=$(idn2 "${options}")
        ;;
    *)
        domainQuery="${options}"
        ;;
esac

# Query specific database tables for matches
scanDatabaseTable() {
    local domain table list_type querystr result
    domain="$(printf "%q" "${1}")"
    table="${2}"
    list_type="${3:-}"

    # Create the appropriate query string
    if [[ "${table}" == "gravity" ]]; then
        case "${exact}" in
            "exact")
                querystr="SELECT gravity.domain, adlist.address, adlist.enabled FROM gravity LEFT JOIN adlist ON adlist.id = gravity.adlist_id WHERE domain = '${domain}'"
                ;;
            *)
                querystr="SELECT gravity.domain, adlist.address, adlist.enabled FROM gravity LEFT JOIN adlist ON adlist.id = gravity.adlist_id WHERE domain LIKE '%${domain//_/\\_}%' ESCAPE '\\'"
                ;;
        esac
    else
        case "${exact}" in
            "exact")
                querystr="SELECT domain, enabled FROM domainlist WHERE type = '${list_type}' AND domain = '${domain}'"
                ;;
            *)
                querystr="SELECT domain, enabled FROM domainlist WHERE type = '${list_type}' AND domain LIKE '%${domain//_/\\_}%' ESCAPE '\\'"
                ;;
        esac
    fi

    # Execute the query
    result="$(pihole-FTL sqlite3 "${gravityDBfile}" "${querystr}")" 2>/dev/null
    if [[ -z "${result}" ]]; then
        return
    fi

    echo "${result}"
}

# Call scan functions for various lists
scanDatabaseTable "${domainQuery}" "whitelist" "0"
scanDatabaseTable "${domainQuery}" "blacklist" "1"
scanDatabaseTable "${domainQuery}" "gravity"

# Exit with success
exit 0
