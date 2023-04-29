import subprocess

# Define the IP address of the server to be protected
server_ip = "192.168.1.100"

# Define the maximum number of connections per IP address
max_connections = 50

# Define the maximum number of connections per minute per IP address
max_conn_per_min = 10

# Define the ports to be protected (80 and 443 are commonly targeted by DDoS attacks by FTLDNS added as extra precaution)
ports = ["80", "443", "53"]

# Define the iptables commands to be executed
iptables_cmds = [
    f"iptables -A INPUT -p tcp --syn --dport {port} -m connlimit --connlimit-above {max_connections} -j REJECT --reject-with tcp-reset"
    for port in ports
] + [
    f"iptables -A INPUT -p tcp --dport {port} -m state --state NEW -m recent --set --name DDOS --rsource",
    f"iptables -A INPUT -p tcp --dport {port} -m state --state NEW -m recent --update --seconds 60 --hitcount {max_conn_per_min} --rttl --name DDOS --rsource -j REJECT --reject-with tcp-reset"
    for port in ports
]

# Execute the iptables commands
for cmd in iptables_cmds:
    subprocess.run(cmd.split(), check=True)

# Save the iptables rules
subprocess.run("iptables-save > /etc/iptables/rules.v4", shell=True, check=True)

# Display a message indicating that the rules have been successfully created
print("iptables rules have been successfully created to protect against DDoS attacks.")
