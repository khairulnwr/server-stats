#!/bin/bash

# Script: server-stats.sh
# Deskripsi: Menampilkan statistik CPU, memori, disk, dan proses teratas

echo "====[ STATISTIK SERVER ]===="
echo ""

# ===== PENGGUNAAN CPU =====
echo ">> Penggunaan CPU Total:"
top -bn1 | grep "Cpu(s)" | \
awk '{penggunaan=100 - $8; printf "Penggunaan CPU: %.2f%%\n", penggunaan}'
echo ""

# ===== PENGGUNAAN MEMORI =====
echo ">> Penggunaan Memori (RAM):"
read total used free <<< $(free -m | awk '/Mem:/ {print $2, $3, $4}')
persentase=$(awk "BEGIN {printf \"%.2f\", ($used/$total)*100}")
total_gb=$(awk "BEGIN {printf \"%.2f\", $total/1024}")
used_gb=$(awk "BEGIN {printf \"%.2f\", $used/1024}")
free_gb=$(awk "BEGIN {printf \"%.2f\", $free/1024}")

echo "Total Memori   : ${total_gb} GB"
echo "Digunakan      : ${used_gb} GB"
echo "Tersisa (Free) : ${free_gb} GB"
echo "Persentase     : ${persentase}%"
echo ""

# ===== PENGGUNAAN DISK =====
echo ">> Penggunaan Disk (/) :"
disk_info=$(df -h / | awk 'NR==2')
total_disk=$(echo $disk_info | awk '{print $2}')
used_disk=$(echo $disk_info | awk '{print $3}')
avail_disk=$(echo $disk_info | awk '{print $4}')
used_percent=$(echo $disk_info | awk '{print $5}')

echo "Total Disk     : ${total_disk}"
echo "Digunakan      : ${used_disk}"
echo "Tersisa (Free) : ${avail_disk}"
echo "Persentase     : ${used_percent}"
echo ""

# ===== TOP 5 PROSES CPU =====
echo ">> 5 Proses dengan Penggunaan CPU Tertinggi:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
echo ""

# ===== TOP 5 PROSES MEMORI =====
echo ">> 5 Proses dengan Penggunaan Memori Tertinggi:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
echo ""

