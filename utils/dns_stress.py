import dns.resolver
import time
import concurrent.futures

# Set the DNS server IP address
dns_server = '192.168.100.64' # Change to your GATE's FTL or Unbound dedicated DNS IP address.

# Set the domain name to resolve
domain_name = 'cwd.systems'

# Set the number of queries to make
num_queries = 1000

# Set the maximum number of parallel queries
max_workers = 10

# Create a DNS resolver object
resolver = dns.resolver.Resolver(configure=False)
resolver.nameservers = [dns_server]

# Define a function to perform a single DNS query
def perform_query(query_num):
    try:
        answer = resolver.resolve(domain_name)
        print(f'Query {query_num}: {answer}')
    except dns.resolver.NXDOMAIN:
        print(f'Query {query_num}: domain does not exist')
    except dns.resolver.Timeout:
        print(f'Query {query_num}: timed out')
    except dns.resolver.NoAnswer:
        print(f'Query {query_num}: no answer')
    except dns.resolver.NoNameservers:
        print(f'Query {query_num}: no nameservers found')

# Perform the DNS lookups in parallel and time it
start_time = time.time()
with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
    for i in range(num_queries):
        executor.submit(perform_query, i+1)
end_time = time.time()

# Calculate the total query time and queries per second
total_query_time = end_time - start_time
queries_per_second = num_queries / total_query_time

# Print the results
print(f'Total query time: {total_query_time:.3f} seconds')
print(f'Queries per second: {queries_per_second:.1f}')
