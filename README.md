# Automated Media Management System

This project provides a complete, automated pipeline for managing a large personal media library. It uses a Linux server to watch a "staging" directory for new photos and videos, deduplicates them against a central database, applies age-based compression, archives the originals, and uploads the processed versions to a cloud service like Google Photos.

## Features ✨

* **Database-Driven:** Uses an SQLite database to track every file, its metadata, and processing status.
* **Automatic Deduplication:** Calculates a unique hash for each file to prevent duplicates from ever entering your library.
* **Tiered Compression:** Intelligently compresses older photos and videos to save cloud storage space while keeping originals safe.
* **Scalable Configuration:** Uses a central `config.conf` file and command-line arguments for easy management.
* **Robust Automation:** Leverages `systemd` timers for reliable, scheduled execution.
* **Cloud Integration:** Uploads processed media to any cloud provider supported by `rclone`.

## Prerequisites

* A Linux server (physical or virtual). This guide is tailored for **Ubuntu 22.04 LTS**.
* A NAS or storage location accessible from the server.
* `git` installed on the server to clone this repository.

## Installation ⚙️

1.  **Clone the Repository**
    ```bash
    git clone <your-repository-url>
    cd automated-media-server
    ```

2.  **Mount Your NAS**
    Before running the setup, ensure your main NAS storage is mounted on the server. The scripts assume it is mounted at `/data/nas`. You should have a `staging` sub-folder inside it where new media will be placed.

3.  **Create Your Configuration**
    Copy the example config file and edit it to match your environment.
    ```bash
    cp config.conf.example config.conf
    nano config.conf
    ```
    Update the paths and quality settings as needed.

4.  **Run the Setup Script**
    This script will install all required software (`rclone`, `ffmpeg`, `sqlite3`, etc.), create directories, and initialize the database. It only needs to be run once.
    ```bash
    chmod +x setup_media_server.sh
    sudo ./setup_media_server.sh
    ```

5.  **Configure Rclone**
    If you haven't already, run `rclone config` to set up your cloud storage remote (e.g., `gphotos`). Make sure the `RCLONE_REMOTE` value in your `config.conf` matches the name you give it.

## Automation with `systemd`

To run the processing script automatically, we use a `systemd` timer.

1.  **Copy the Scripts and Units**
    Move the main script to a system path and copy the service/timer files to the `systemd` directory.
    ```bash
    sudo cp process_media.sh /usr/local/bin/
    sudo chmod +x /usr/local/bin/process_media.sh
    sudo cp systemd/media_processor.* /etc/systemd/system/
    ```

2.  **Enable and Start the Timer**
    This will start the timer and ensure it automatically runs on boot. By default, it runs 5 minutes after boot and then every 30 minutes.
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl enable media_processor.timer
    sudo systemctl start media_processor.timer
    ```

3.  **Check the Status**
    You can check that the timer is active and see when it's scheduled to run next with:
    ```bash
    sudo systemctl status media_processor.timer
    ```
    To see the logs from the last run of the script, use:
    ```bash
    journalctl -u media_processor.service
    ```

## Usage Workflow 🚀

1.  **Add Media:** Transfer new photos and videos into the `staging` directory you defined in your `config.conf`. A tool like **PhotoSync** is perfect for this.
2.  **Wait:** The `systemd` timer will automatically trigger the `process_media.sh` script.
3.  **Monitor:** The script will:
    * Check for duplicates against the database.
    * Process unique files based on your tiered compression rules.
    * Move the original files to your `archive` directory.
    * Place the processed files in the `to_upload` directory.
    * Run `rclone` to upload the queue to the cloud.
4.  **Check Logs:** You can review the log files in your configured `LOG_DIR` or via `journalctl` to see what the script has done.
