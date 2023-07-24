#!/bin/bash

# Define log file
LOG_FILE="/var/log/setup.log"

# Make sure the file exists
touch $LOG_FILE

# Function to log information
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a $LOG_FILE
}

# Function to log error
log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a $LOG_FILE
}

# Function to run command and log output
run_cmd() {
    log_info "Running command: $1"
    if ! $1 >> $LOG_FILE 2>&1; then
        log_error "Command failed: $1"
        exit 1
    fi
}

# Start setup
log_info "Starting Setup"

run_cmd "sudo apt-get update -y"
run_cmd "sudo apt-get upgrade -y"
run_cmd "sudo apt-get install unzip git docker.io ansible -y"
run_cmd "sudo systemctl start docker"
run_cmd "sudo systemctl enable docker"
run_cmd "sudo usermod -aG docker ubuntu"
run_cmd "sudo curl -L 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)' -o /usr/local/bin/docker-compose"
run_cmd "sudo chmod +x /usr/local/bin/docker-compose"

log_info "Setup Completed Successfully"
