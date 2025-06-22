#!/bin/bash
# ==============================================================================
#  setup_media_server.sh
#  One-time setup script for the Automated Media Management System
# ==============================================================================

echo "--- Starting Media Server Setup ---"

# --- 1. System Update and Package Installation ---
echo "--- Updating system and installing required packages... ---"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y
apt-get install -y \
    rclone \
    ffmpeg \
    imagemagick \
    exiftool \
    sqlite3 \
    jdupes \
    git

# --- 2. Directory Structure Creation ---
# This script assumes a config file will define the paths later.
# We create the parent directories here as a fallback.
echo "--- Creating parent directory structure... ---"
mkdir -p /data/nas
mkdir -p /data/processed

echo "--- Setup Complete! ---"
echo "Please create and edit your config.conf file."
