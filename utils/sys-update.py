import os
import subprocess
root_password = os.environ.get('ROOT_PASSWORD')
update_command = 'sudo apt-get update && sudo apt-get upgrade -y'

if root_password:
    subprocess.check_call(['sudo', '-S', 'sh', '-c', update_command],
                          input=root_password.encode())
else:
    subprocess.check_call(['sudo', 'sh', '-c', update_command])

cron_job_command = f"echo '{update_command}' | sudo tee -a /etc/cron.daily/package-update && sudo chmod +x /etc/cron.daily/package-update"
subprocess.check_call(['bash', '-c', cron_job_command])

# WIP. Needs debug.
