# Automated System Administration Toolkit

# Overview
This toolkit automates essential local system administration tasks for Linux environments. 

## Features
1.  **User Management:** Automates user creation and deletion with permission handling.
2.  **Log Management:** Rotates and archives system logs to save space.
3.  **System Monitoring:** Checks CPU, Memory, and Disk usage and alerts on high load.
4.  **Network Monitoring:** Scans basic ports and flags the warnings

## Prerequisites
* **OS:** Linux (Ubuntu/Debian)
* **Python:** Version 3.7 or higher
* **Permissions:** Root access (sudo) is required for user management and log access.

## Project Structure
* `toolkit.sh`: The entry point. A bash CLI dashboard that orchestrates the tools (requires SUDO permissions).
* `scripts/`: Contains the individual worker scripts.
* `config.json`: Stores user preferences (backup paths, log directories).

## Setup & Installation
1. Retrieve the latest source code from GitHub to your local machine:
   > git clone https://github.com/atharva-shigvan/sysadmin-toolkit.git
   > cd sysadmin-toolkit
2. Make the necessary files executable
   > chmod +x toolkit.sh && chmod +x scripts/*
3. Run the toolkit (with SUDO permissions)
   > sudo ./toolkit.sh

