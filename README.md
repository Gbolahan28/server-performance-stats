# server-stats.sh

A lightweight Bash script to analyse key performance stats on any Linux server. No dependencies beyond standard Linux tools.

---

## Stats Reported

| Category | Details |
|---|---|
| OS Info | Distribution name and version |
| Uptime & Load | System uptime and 1/5/15-min load averages |
| CPU Usage | Total CPU usage as a percentage |
| Memory Usage | Total, used, and free RAM with percentages |
| Disk Usage | Total, used, and free disk space with percentage |
| Top 5 by CPU | Top 5 processes consuming the most CPU |
| Top 5 by Memory | Top 5 processes consuming the most memory |
| Logged-in Users | Currently active user sessions |
| Failed Logins | Last 5 failed SSH/login attempts (requires root) |

---

## Requirements

- A Linux server (tested on Ubuntu 20.04+, Debian, CentOS/RHEL)
- Bash 4+
- Standard tools: `top`, `ps`, `free`, `df`, `who`, `grep`, `awk` — all pre-installed on any Linux distro

---

## Setup

**1. Clone or download the script**

```bash
git clone https://github.com/Gbolahan28/server-performance-stats.git
cd server-stats
```

Or download the file directly:

```bash
curl -O https://github.com/Gbolahan28/server-performance-stats.git
```

**2. Make it executable**

```bash
chmod +x server-stats.sh
```

---

## Usage

**Run directly:**

```bash
./server-stats.sh
```

**Or with bash explicitly:**

```bash
bash server-stats.sh
```

**Run as root** to include failed login attempts from the auth log:

```bash
sudo ./server-stats.sh
```

---

## Sample Output

```
====================================================
 Server Performance Stats - Mon Jun 23 10:45:01 UTC 2026
====================================================
--------------------------------------------------
OS Version:
Ubuntu 24.04.4 LTS
--------------------------------------------------
Uptime & Load Average:
 10:45:01 up 12 days, 3:22,  2 users,  load average: 0.45, 0.38, 0.32
--------------------------------------------------
Total CPU Usage:
CPU Usage: 9.10%
--------------------------------------------------
Total Memory Usage:
Total: 3997 MB | Used: 218 MB (5.45%) | Free: 3860 MB (96.57%)
--------------------------------------------------
Total Disk Usage:
Total: 100G | Used: 18G (19%) | Free: 82G
--------------------------------------------------
Top 5 Processes by CPU Usage:
  PID COMMAND         %CPU %MEM
 1042 nginx            7.3  0.1
  491 node             5.0  0.8
...
```

---

## Notes

- **Failed login attempts** are read from `/var/log/auth.log` (Debian/Ubuntu) or `/var/log/secure` (CentOS/RHEL). Root privileges are required to access these files.
- **CPU calculation** uses `top` by default, with a `/proc/stat` fallback if `top` output is unavailable.
- The script is read-only — it makes no changes to your system.

---

## License

MIT

## Project URL

https://roadmap.sh/projects/server-stats