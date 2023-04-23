import subprocess
import matplotlib.pyplot as plt
output = subprocess.check_output(["vcgencmd", "measure_temp"])
temp = float(output.decode("utf-8").split("=")[1].split("'")[0])
plt.plot(temp)
plt.title("Board Temperature")
plt.xlabel("Time (s)")
plt.ylabel("Temperature (C)")
plt.show()
