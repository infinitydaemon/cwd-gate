import speedtest

def run_speed_test():
    speed_test = speedtest.Speedtest()

    print("Running speed test...")
    download_speed = speed_test.download() / 1024 / 1024
    upload_speed = speed_test.upload() / 1024 / 1024
    ping = speed_test.results.ping
    
    print(f"Download speed: {download_speed:.2f} Mbps")
    print(f"Upload speed: {upload_speed:.2f} Mbps")
    print(f"Ping: {ping:.2f} ms")

if __name__ == "__main__":
    run_speed_test()
