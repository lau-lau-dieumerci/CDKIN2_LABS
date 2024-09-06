import smtplib
import subprocess
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

def get_system_performance():
    memory_usage = subprocess.check_output(['free', '-m']).decode('utf-8')
    cpu_usage = subprocess.check_output(['top', '-b', '-n1']).decode('utf-8').split('\n')[2]
    disk_usage = subprocess.check_output(['df', '-h']).decode('utf-8')
    return memory_usage, cpu_usage, disk_usage

def send_email(subject, body, to_email):
    from_email = "ton_email@gmail.com"
    password = "mot_de_passe_email"

    message = MIMEMultipart()
    message['From'] = from_email
    message['To'] = to_email
    message['Subject'] = subject
    message.attach(MIMEText(body, 'plain'))

    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login(from_email, password)
    server.sendmail(from_email, to_email, message.as_string())
    server.quit()

if __name__ == "__main__":
    memory, cpu, disk = get_system_performance()
    performance_report = f"Performancne Mémoire : \n{memory}\n\n CPU Usage : \n{cpu} %\n\n Disk Usage : \n{disk}"
    send_email("Server Performance Report Rapport de performance du Server (CPU)", performance_report, "destinataire@example.com")

