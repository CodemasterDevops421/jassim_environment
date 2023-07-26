#!/bin/bash

# Define log file
LOG_FILE="/home/ubuntu/setup.log"

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
run_cmd "sudo apt install ansible -y"
run_cmd "sudo apt-get install nginx -y"
run_cmd "sudo apt-get install php8.1 -y"
run_cmd "sudo apt-get install php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath php8.1-fpm -y"
run_cmd "sudo systemctl restart nginx"
run_cmd "sudo systemctl restart php8.1-fpm"
run_cmd "sudo mkdir -p /var/www/html/"
run_cmd "sudo chown -R ubuntu:ubuntu /var/www/html/"
run_cmd "mkdir -p /var/www/html/storage/framework/{sessions,views,cache}"
run_cmd "chmod -R ugo+rw /var/www/html/storage/framework"
run_cmd "sudo mkdir -p /var/www/html/storage/logs"
run_cmd "sudo chmod -R ugo+rw /var/www/html/storage/logs"
run_cmd "sudo apt-get install docker.io -y"
run_cmd "sudo systemctl start docker"
run_cmd "sudo systemctl enable docker"
run_cmd "sudo usermod -aG docker ubuntu"
run_cmd "sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose"
run_cmd "sudo chmod +x /usr/local/bin/docker-compose"
run_cmd "sudo apt-add-repository --yes --update ppa:ansible/ansible"


log_info "Setup Completed Successfully"
