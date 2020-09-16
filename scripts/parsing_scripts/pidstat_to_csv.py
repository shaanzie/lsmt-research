#!/usr/bin/python3

import sys

file = open(sys.argv[1], 'r')
out_file = open(sys.argv[1][:-8] + "-pidstat.csv", "w")

heading = "# Time        UID       PID    %usr %system  %guest   %wait    %CPU   CPU  minflt/s  majflt/s     VSZ     RSS   %MEM StkSize  StkRef   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command"

out_file.write(",".join(heading.split()[4:-1]) + ",Workload\n")

workload = sys.argv[1].split("/")[-1][:-8]

considered_lines = []

flag = 0

for line in file.readlines():
    if("python3" in line and flag == 1):
        considered_lines.append(line)
    flag = 1 - flag
for line in considered_lines:
        out_file.write(",".join(line.split()[3:-1]) + "," + workload + "\n")

out_file.close()