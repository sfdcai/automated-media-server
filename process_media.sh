#!/bin/bash
# ==============================================================================
#  process_media.sh (v3 - With Processing Limit)
#  Processes media based on a config file and command-line arguments.
# ==============================================================================
set -e

# --- Default Configuration ---
# Assume config is in the same directory as the script if not specified.
SCRIPT_DIR=<span class="math-inline">\(cd \-\- "</span>(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
CONFIG_FILE="$SCRIPT_DIR/config.conf"
DAILY_PROCESSING_LIMIT="1000"

# --- Help Function ---
show_help() {
    # ... (help function from previous response) ...
}

# --- Load Configuration File ---
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "ERROR: config.conf not found at $CONFIG_FILE. Exiting."
    exit 1
fi

# --- Parse Command-Line Arguments ---
# ... (argument parsing logic from previous response) ...

# Ensure necessary directories exist based on config
mkdir -p "$STAGING_DIR" "$ARCHIVE_DIR" "$PROCESSED_DIR" "$LOG_DIR"

# --- SCRIPT EXECUTION STARTS HERE ---
log() {
    # ... (log function from previous response) ...
}

echo "--- Starting media processing run with limit: $DAILY_PROCESSING_LIMIT ---"
processed_count=0

# --- Main Processing Loop ---
find "$STAGING_DIR" -type f | while read -r file; do
    
    if [[ "$processed_count" -ge "$DAILY_PROCESSING_LIMIT" ]]; then
        log "PROCESSING LIMIT REACHED: <span class="math-inline">processed\_count files processed\. Exiting loop\."
break
fi
\# \.\.\. \(The entire deduplication and tiered compression logic from previous responses\) \.\.\.
\# This is where you would place the full find/hash/check/process/log/move logic\.
\# After a file is successfully processed\:
\# processed\_count\=</span>((processed_count + 1))

done

# --- Final Upload Step ---
# ... (rclone upload logic) ...

log "--- Media processing run finished ---"
