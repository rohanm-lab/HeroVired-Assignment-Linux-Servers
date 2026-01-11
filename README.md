# HeroVired-Assignment-Linux-Servers
Created this repository for submitting the Practice-Assignment-Linux-Servers

# HeroVired-Linux-Assignment
# DevOps System Setup and Automation Assignment

## Overview
- This project demonstrates the implementation of a secure, monitored, and well-maintained development environment for two developers, **Sarah** and **Mike**, at TechCorp.  
- The setup includes **system monitoring**, **user management with access control**, and **automated backup configuration** for Apache and Nginx web servers.

#### The goal is to follow DevOps best practices for **performance monitoring**, **security**, and **data protection**.

---

## Task 1: System Monitoring Setup

### Objective
To monitor CPU usage, memory utilization, running processes, and disk usage for effective troubleshooting and capacity planning.

### Tools Used
- `htop` (or `nmon`)
- `df`
- `du`
- `ps`

---

### Step 1: Install Monitoring Tool

```bash
# yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
# yum install nmon htop -y
```

### Step 2: Verify the installation
```bash
# rpm -qa | grep htop
htop-3.3.0-1.el9.x86_64

# rpm -qa | grep -w nmon
nmon-16p-1.el9.x86_64
```

### Step 3: Monitor System Resources
- You need to run `htop` command as follows to use the tool:
```bash
# htop
```

#### This command provides real-time monitoring of:
- CPU usage
  - CPU usage → Top bar
- Memory consumption
  - Memory usage → RAM bar
- Active processes
  - Resource-intensive processes → Sorted automatically

#### Here is the small Example of `htop` tool
<img width="1915" height="1062" alt="image" src="https://github.com/user-attachments/assets/ecab6e79-aa8b-4ff6-8d8a-d5b3a7c1739b" />

- You need to run `nmon` command as follows to use the tool:
```bash
# nmon
```

- Press:
  - c → CPU
  - m → Memory
  - d → Disk
  - t → Top processes

#### Here is the small Example of `nmon` tool
<img width="1915" height="983" alt="image" src="https://github.com/user-attachments/assets/03710055-108f-43ab-9389-061fae9b4043" />


### Step 4: Disk Usage Monitoring
- Check overall disk usage with command `df -h`:

```bash
# df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        4.0M     0  4.0M   0% /dev
tmpfs            16G     0   16G   0% /dev/shm
tmpfs           6.3G   17M  6.3G   1% /run
/dev/xvda4       99G  3.2G   96G   4% /
/dev/xvda3      960M  184M  777M  20% /boot
/dev/xvda2      200M  7.1M  193M   4% /boot/efi
tmpfs           3.2G     0  3.2G   0% /run/user/1000
```
- Check directory-level usage with command `du -sh <path>`:
```bash
# du -sh /var/*
0	/var/adm
361M	/var/cache
71M	/var/lib
3.5M	/var/log
12K	/var/spool
4.0K	/var/tmp
```

### Step 5: Identify Resource-Intensive Processes using `ps` command
```bash
# ps aux --sort=-%mem | head -10
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         827  0.0  0.0 258616 26936 ?        Ssl  14:05   0:00 /usr/bin/python3 -Es /usr/sbin/tuned -l -P
root         798  0.0  0.0 259880 24256 ?        Ssl  14:05   0:00 /usr/sbin/NetworkManager --no-daemon
polkitd     1073  0.0  0.0 2918904 23056 ?       Ssl  14:05   0:00 /usr/lib/polkit-1/polkitd --no-debug
root           1  0.0  0.0 175548 19464 ?        Ss   14:05   0:03 /usr/lib/systemd/systemd --switched-root --system --deserialize 31
ec2-user    3401  0.0  0.0  24344 14208 ?        Ss   15:28   0:00 /usr/lib/systemd/systemd --user
root         645  0.0  0.0  37916 12876 ?        Ss   14:05   0:00 /usr/lib/systemd/systemd-udevd
root        3397  0.0  0.0  21136 12672 ?        Ss   15:28   0:00 sshd: ec2-user [priv]
root         768  0.0  0.0  22532 11552 ?        Ss   14:05   0:00 /usr/lib/systemd/systemd-logind
root         631  0.0  0.0  28228 11136 ?        Ss   14:05   0:00 /usr/lib/systemd/systemd-journald

# ps aux --sort=-%cpu | head -10
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0 175548 19464 ?        Ss   14:05   0:03 /usr/lib/systemd/systemd --switched-root --system --deserialize 31
root           2  0.0  0.0      0     0 ?        S    14:05   0:00 [kthreadd]
root           3  0.0  0.0      0     0 ?        S    14:05   0:00 [pool_workqueue_]
root           4  0.0  0.0      0     0 ?        I<   14:05   0:00 [kworker/R-rcu_g]
root           5  0.0  0.0      0     0 ?        I<   14:05   0:00 [kworker/R-sync_]
root           6  0.0  0.0      0     0 ?        I<   14:05   0:00 [kworker/R-slub_]
root           7  0.0  0.0      0     0 ?        I<   14:05   0:00 [kworker/R-netns]
root           9  0.0  0.0      0     0 ?        I<   14:05   0:00 [kworker/0:0H-events_highpri]
root          10  0.0  0.0      0     0 ?        I    14:05   0:00 [kworker/u60:0-events_unbound]
```

### Step 6: Create Monitoring Logs using script call `system_monitor.sh`
- Create log directory
```bash
# mkdir -p /var/log/system-monitor
```

- Create monitoring script
```bash
# vi /usr/local/bin/system_monitor.sh
# cat /usr/local/bin/system_monitor.sh
#!/bin/bash
echo "===== System Monitoring Report =====" >> /var/log/system-monitor/monitor.log
date >> /var/log/system-monitor/monitor.log
echo "CPU & Memory:" >> /var/log/system-monitor/monitor.log
echo "=============" >> /var/log/system-monitor/monitor.log
top -b -n 1 | head -10 >> /var/log/system-monitor/monitor.log
echo "Disk Usage:" >> /var/log/system-monitor/monitor.log
echo "=============" >> /var/log/system-monitor/monitor.log
df -h >> /var/log/system-monitor/monitor.log
echo "----------------------------------" >> /var/log/system-monitor/monitor.log
```

- Make the bash script executable
```bash
# chmod +x /usr/local/bin/system_monitor.sh
```

- Testing the script run manually
```bash
# /usr/local/bin/system_monitor.sh
```

<img width="1284" height="775" alt="image" src="https://github.com/user-attachments/assets/ad2b2a49-ddcb-4bd7-8542-3245f1f6bcf9" />


## Task 2: User Management and Access Control
### Objective
- The following is to create users Sarah & Mike, isolated directories, permissions, and password policy.

### Step 1: Create User Accounts
```bash
# sudo useradd sarah
# sudo useradd mike
```

- Set passwords
```bash
# echo <Password> | passwd --stdin sarah
# echo <Password> | passwd --stdin mike
```
<img width="1290" height="311" alt="image" src="https://github.com/user-attachments/assets/e5fc691a-4978-4609-b857-8c2c8682a2bf" />


### Step 2: Create Isolated Work Directories
- Run the following command to create Workspace Directory and verify the same
```bash
# mkdir -p /home/{sarah,mike}/workspace
# ll /home/sarah/workspace/ /home/mike/workspace/
/home/mike/workspace/:
total 0

/home/sarah/workspace/:
total 0
```

- Assign ownership
```bash
# sudo chown -R sarah:sarah /home/sarah/workspace
# sudo chown -R mike:mike /home/mike/workspace
```

- Restrict permissions
```bash
# sudo chmod 700 /home/sarah/workspace
# sudo chmod 700 /home/mike/workspace
```

- Verify the Directories
```bash
# ls -ld /home/sarah/workspace
# ls -ld /home/mike/workspace
```

<img width="1405" height="443" alt="image" src="https://github.com/user-attachments/assets/fe55d657-4991-4813-9f1d-af0ad6511c2f" />


### Step 3: Enforce Password Expiration (30 Days)
- `chage` command will help to set the Password Expiration
```bash
# sudo chage -M 30 sarah
# sudo chage -M 30 mike
```

- Verify policy
```bash
# sudo chage -l sarah
# sudo chage -l mike
```

<img width="1405" height="467" alt="image" src="https://github.com/user-attachments/assets/c9ac218c-54b3-4aba-a639-f5c59e542dcc" />


### Step 4: Enforce Password Complexity
- This step is about forcing strong passwords on a Linux system (RHEL/CentOS/Rocky/Alma etc.) using PAM (Pluggable Authentication Modules) via the pwquality module.
  - Edit PAM configuration:
```bash
# sudo vi /etc/security/pwquality.conf
```
  - Set the following in `pwquality.conf` file:
<img width="1266" height="194" alt="image" src="https://github.com/user-attachments/assets/e47e5dba-ec30-47d9-9c83-05dbf6ae7a5e" />

- These settings enforce that every password must have:
  - Minimum 8 characters
  - 1 uppercase letter
  - 1 lowercase letter
  - 1 number(digit)
  - 1 special character

- Example of a Valid Password
```
MySecure@123
```
- Example of an Invalid Password
```
password123
```

## Task 3: Backup Configuration for Web Servers
### Objective
- To automate weekly backups of Apache and Nginx servers with integrity verification.

### Step 1: Create Backup Directory
```bash
# sudo mkdir /backups
# sudo chmod 755 /backups
```

### Step 2: Apache Backup Script for user(Sarah)
- Create backup script:

```bash
# sudo nano /usr/local/bin/apache_backup.sh
# sudo cat /usr/local/bin/apache_backup.sh
#!/bin/bash
DATE=$(date +%F)
tar -czf /backups/apache_backup_$DATE.tar.gz /etc/httpd /var/www/html
tar -tzf /backups/apache_backup_$DATE.tar.gz > /backups/apache_verify_$DATE.log
```

- Make executable:
```bash
# sudo chmod +x /usr/local/bin/apache_backup.sh
```

<img width="1315" height="147" alt="image" src="https://github.com/user-attachments/assets/c5202037-ac9d-446a-b14d-995552e1648b" />


### Step 3: Nginx Backup Script for user(Mike)
```bash
# sudo nano /usr/local/bin/nginx_backup.sh
# sudo cat /usr/local/bin/nginx_backup.sh
#!/bin/bash
DATE=$(date +%F)
tar -czf /backups/nginx_backup_$DATE.tar.gz /etc/nginx /usr/share/nginx/html
tar -tzf /backups/nginx_backup_$DATE.tar.gz > /backups/nginx_verify_$DATE.log
```

- Make Script executable:
```bash
# sudo chmod +x /usr/local/bin/nginx_backup.sh
```

### Step 4: Schedule Cron Jobs
- Edit cron which runs every Tuesday at 12:00 AM:
```bash
# sudo crontab -e
# sudo crontab -l
0 0 * * 2 /usr/local/bin/apache_backup.sh
0 0 * * 2 /usr/local/bin/nginx_backup.sh
```
<img width="891" height="167" alt="image" src="https://github.com/user-attachments/assets/cd2dea21-2e66-4d63-9cf8-fea6f745a9ad" />


### Step 5: Verify Backup Creation
```bash
# ls -lh /backups/
# cat /backups/apache_verify_YYYY-MM-DD.log
# cat /backups/nginx_verify_YYYY-MM-DD.log
```

<img width="1197" height="600" alt="image" src="https://github.com/user-attachments/assets/158b685d-1247-46fd-a5d6-3da7602e464d" />
