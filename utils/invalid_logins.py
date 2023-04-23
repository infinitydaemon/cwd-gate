import re
import datetime
import matplotlib.pyplot as plt

invalid_login_regex = r'.*Failed password.*from.*'
auth_log_path = '/var/log/auth.log'
invalid_logins_by_date = {}
with open(auth_log_path, 'r') as auth_log_file:
    for line in auth_log_file:
        match = re.match(invalid_login_regex, line)
        if match:
            date_str = line.split()[0]  # Extract date from auth.log line
            date = datetime.datetime.strptime(date_str, '%b %d')  # Parse date string
            invalid_logins_by_date[date] = invalid_logins_by_date.get(date, 0) + 1
sorted_invalid_logins = sorted(invalid_logins_by_date.items())
dates, counts = zip(*sorted_invalid_logins)
plt.plot(dates, counts)
plt.xlabel('Date')
plt.ylabel('Invalid Login Attempts')
plt.title('Invalid Login Attempts Over Time')
plt.show()
