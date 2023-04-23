#!/bin/bash
echo "Doing a total flush"
sudo du /etc/pihole/pihole-FTL.db -h && pihole flush && sudo systemctl stop pihole-FTL && sudo rm /etc/pihole/pihole-FTL.db && sudo systemctl start pihole-FTL
echo "Done!"
