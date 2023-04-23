import re
import datetime
import matplotlib.pyplot as plt
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

invalid_login_regex = r'.*Failed password.*from.*'
health_event_regex = r'.*kernel:.*'
auth_log_path = '/var/log/auth.log'
sys_log_path = '/var/log/syslog'
health_event_threshold = 50
email_from = 'your_email@gmail.com'
email_password = 'your_email_password'
email_to = 'recipient_email@gmail.com'
smtp_server = 'smtp.gmail.com'
smtp_port = 587


invalid_logins_by_date = {}
with open(auth_log_path, 'r') as auth_log_file:
    for line in auth_log_file:
        match = re.match(invalid_login_regex, line)
        if match:
            date_str = line.split()[0] 
            date = datetime.datetime.strptime(date_str, '%b %d') 
            invalid_logins_by_date[date] = invalid_logins_by_date.get(date, 0) + 1

health_events_by_date = {}
with open(sys_log_path, 'r') as sys_log_file:
    for line in sys_log_file:
        match = re.match(health_event_regex, line)
        if match:
            date_str = line.split()[0]
            date = datetime.datetime.strptime(date_str, '%b %d') 
            health_events_by_date[date] = health_events_by_date.get(date, 0) + 1

sorted_invalid_logins = sorted(invalid_logins_by_date.items())
sorted_health_events = sorted(health_events_by_date.items())
dates, invalid_counts = zip(*sorted_invalid_logins)
_, health_counts = zip(*sorted_health_events)
fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True, figsize=(10, 8))
ax1.plot(dates, invalid_counts)
ax1.set_ylabel('Invalid Login Attempts')
ax2.plot(dates, health_counts)
ax2.set_xlabel('Date')
ax2.set_ylabel('System Health Events')
ax1.set_title('Invalid Login Attempts and System Health Events Over Time')
plt.show()

if sum(health_counts) > health_event_threshold:
    message = MIMEMultipart()
    message['From'] = email_from
    message['To'] = email_to
    message['Subject'] = 'System Health Event Notification'
    body = f'The system has experienced {sum(health_counts)} health events.'
    message.attach(MIMEText(body, 'plain'))
    server = smtplib.SMTP(smtp_server, smtp_port)
    server.starttls()
    server.login(email_from, email_password)
    text = message.as_string()
    server.sendmail(email_from, email_to, text)
    server.quit()
