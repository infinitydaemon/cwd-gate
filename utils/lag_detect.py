import psutil

def check_lagging_processes(threshold):
    processes = psutil.process_iter(attrs=['pid', 'name', 'cpu_percent'])

    lagging_processes = []
    for process in processes:
        pid = process.info['pid']
        name = process.info['name']
        cpu_percent = process.info['cpu_percent']

        if cpu_percent > threshold:
            lagging_processes.append({'pid': pid, 'name': name, 'cpu_percent': cpu_percent})

    if lagging_processes:
        print("Lagging processes:")
        for process in lagging_processes:
            print(f"PID: {process['pid']}, Name: {process['name']}, CPU Percent: {process['cpu_percent']}")
    else:
        print("No lagging processes found.")

if __name__ == "__main__":
    threshold = 80
    check_lagging_processes(threshold)
