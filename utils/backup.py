import subprocess
import shutil
import datetime

# Specify the source and destination paths
source_path = "/dev/mmcXXX"  # Replace with the actual path of the device
destination_path = "/path/to/backup/location"  # Replace with the desired backup destination path

# Generate a timestamp for the backup file
timestamp = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")

# Create a filename for the backup
backup_filename = f"backup_{timestamp}.img"

# Create a full backup of the microSD card using dd command
backup_command = f"sudo dd bs=4M if={source_path} of={destination_path}/{backup_filename}"
subprocess.run(backup_command, shell=True)

# Compress the backup file (optional)
compressed_backup_filename = f"backup_{timestamp}.zip"
shutil.make_archive(destination_path + "/" + compressed_backup_filename, "zip", destination_path, backup_filename)

# Print backup completion message
print("Backup completed successfully!")
