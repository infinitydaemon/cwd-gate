import socks
import socket
import requests
import time

# Set the IP address and port of the Tor SOCKS proxy running on GATE Appliance
proxy_ip = '192.168.100.64' # Change to your CWD Gate IP address
proxy_port = 9050

# Set the Tor check URL to test internet connectivity and download speed
test_url = 'https://check.torproject.org/'

# Create a socket object for the Tor proxy
socks.setdefaultproxy(socks.PROXY_TYPE_SOCKS5, proxy_ip, proxy_port)

# Wrap the socket object with the urllib library
socket.socket = socks.socksocket

# Test the connection and get the latency
start_time = time.time()
response = requests.get(test_url)
end_time = time.time()
latency = end_time - start_time

# Check if the connection was successful
if response.status_code == 200:
    print(f"Connection successful! Latency: {latency:.3f} seconds.")
    
    # Measure the download speed
    start_time = time.time()
    for i in range(10):
        requests.get(test_url)
    end_time = time.time()
    download_speed = (10 * len(response.content)) / (end_time - start_time)
    
    print(f"Download speed: {download_speed:.2f} bytes/second")
    
else:
    print("Connection failed.")
