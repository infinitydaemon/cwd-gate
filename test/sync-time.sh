#!/bin/bash
# Set the time server you want to use
TIMESERVER="pool.ntp.org"

# Run ntpdate to update the system clock
ntpdate -u $TIMESERVER
