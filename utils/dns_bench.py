import dns.resolver
import time

# Set the DNS server IP address
dns_server = '192.168.100.64' # Replace with your FTP DNS IP

# Set the domain name to resolve
domain_name = 'cwd.systems'

# Set the number of queries to make
num_queries = 2000 # Send heavy requests

# Create a DNS resolver object
resolver = dns.resolver.Resolver(configure=False)
resolver.nameservers = [dns_server]

# Perform the DNS lookup and time it
start_time = time.time()
for i in range(num_queries):
    answer = resolver.resolve(domain_name)
    print(answer)
end_time = time.time()

# Calculate the average query time
avg_query_time = (end_time - start_time) / num_queries
print(f'Average query time: {avg_query_time:.3f} seconds')

# Sample output of CWD GATE DNS for 2000 requests
#
# <dns.resolver.Answer object at 0x107dcce90>
# <dns.resolver.Answer object at 0x107dcd190>
# ...
# <dns.resolver.Answer object at 0x107dcc190>
# <dns.resolver.Answer object at 0x107dccfd0>
# Average query time: 0.001 seconds
