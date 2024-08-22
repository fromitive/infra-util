#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Step 1: Create a systemd service file
echo -e "${GREEN}Creating systemd service file...${NC}"
SERVICE_PATH="/etc/systemd/system/github-actions.service"
sudo bash -c "cat > $SERVICE_PATH <<EOL
[Unit]
Description=Github Actions Runner Restart Service
After=network.target

[Service]
ExecStart=/home/ubuntu/actions-runner/run.sh
Restart=always
User=ubuntu

[Install]
WantedBy=multi-user.target
EOL"

# Check if the service file was created successfully
if [ -f "$SERVICE_PATH" ]; then
    echo -e "${GREEN}Service file created successfully at $SERVICE_PATH${NC}"
else
    echo -e "${RED}Failed to create service file${NC}"
    exit 1
fi

# Step 2: Reload systemd daemon
echo -e "${GREEN}Reloading systemd daemon...${NC}"
sudo systemctl daemon-reload

# Step 3: Enable the service
echo -e "${GREEN}Enabling the service to start on boot...${NC}"
sudo systemctl enable github-actions.service

# Check if the service was enabled successfully
if systemctl is-enabled --quiet github-actions.service; then
    echo -e "${GREEN}Service enabled successfully${NC}"
else
    echo -e "${RED}Failed to enable the service${NC}"
    exit 1
fi

# Step 4: Start the service
echo -e "${GREEN}Starting the service...${NC}"
sudo systemctl start github-actions.service

# Check if the service is active (running)
if systemctl is-active --quiet github-actions.service; then
    echo -e "${GREEN}Service started successfully${NC}"
else
    echo -e "${RED}Failed to start the service${NC}"
    exit 1
fi

# Step 5: Check the status of the service
echo -e "${GREEN}Checking the status of the service...${NC}"
sudo systemctl status github-actions.service --no-pager

