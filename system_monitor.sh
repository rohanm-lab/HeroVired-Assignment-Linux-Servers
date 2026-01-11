#!/bin/bash
echo "===== System Monitoring Report =====" >> /var/log/system-monitor/monitor.log
date >> /var/log/system-monitor/monitor.log
echo "CPU & Memory:" >> /var/log/system-monitor/monitor.log
echo "==========" >> /var/log/system-monitor/monitor.log
top -b -n 1 | head -10 >> /var/log/system-monitor/monitor.log
echo "Disk Usage:" >> /var/log/system-monitor/monitor.log
echo "==========" >> /var/log/system-monitor/monitor.log
df -h >> /var/log/system-monitor/monitor.log
echo "----------------------------------" >> /var/log/system-monitor/monitor.log
