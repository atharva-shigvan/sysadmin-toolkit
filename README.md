### Automated System Administration Toolkit

# Overview
This toolkit automates essential local system administration tasks for Linux environments. It combines the raw power of **Bash** for system-level operations with the flexibility of **Python** for logic, menu navigation, and complex data handling.

# Features
1.  **User Management:** Automates user creation and deletion with permission handling.
2.  **System Backups:** Configurable file backup with timestamping and compression.
3.  **Log Management:** Rotates and archives system logs to save space.
4.  **System Monitoring:** Checks CPU, Memory, and Disk usage and alerts on high load.

# Prerequisites
* **OS:** Linux (Ubuntu/Debian)
* **Python:** Version 3.7 or higher
* **Permissions:** Root access (sudo) is required for user management and log access.

# Project Structure
* `main.py`: The entry point. A Python CLI dashboard that orchestrates the tools (requires SUDO permissions).
* `scripts/`: Contains the individual worker scripts.
* `config.json`: Stores user preferences (backup paths, log directories).

