import subprocess

print("Doing a total flush")
subprocess.run(['sudo', 'du', '/etc/pihole/pihole-FTL.db', '-h'])
subprocess.run(['pihole', 'flush'])
subprocess.run(['sudo', 'systemctl', 'stop', 'pihole-FTL'])
subprocess.run(['sudo', 'rm', '/etc/pihole/pihole-FTL.db'])
subprocess.run(['sudo', 'systemctl', 'start', 'pihole-FTL'])
print("Done!")
