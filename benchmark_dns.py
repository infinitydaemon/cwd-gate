import time
import dns.resolver

def benchmark_dns_server(server, queries=100):
    resolver = dns.resolver.Resolver()
    resolver.nameservers = [server]

    total_time = 0

    for _ in range(queries):
        start_time = time.time()
        try:
            response = resolver.query('google.com', 'A')
        except dns.exception.DNSException as e:
            print(f"Error querying DNS server: {e}")
            continue

        end_time = time.time()
        query_time = (end_time - start_time) * 1000  # Convert to milliseconds
        total_time += query_time

    avg_response_time = total_time / queries
    print(f"Avg. Response Time for {queries} queries: {avg_response_time:.2f} ms")

if __name__ == "__main__":
    dns_server = "192.168.1.10"  # Change this to the CWD GATE's DNS resolver
    num_queries = 3500

    benchmark_dns_server(dns_server, num_queries)
