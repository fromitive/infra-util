#!/bin/bash

# install cloudwatch arm64 version
wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/arm64/latest/amazon-cloudwatch-agent.deb 

# install cloudwatch
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

