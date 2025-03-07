#!/bin/bash

# Update package lists and install required packages
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jdk maven git

# Set GitHub token for authentication
export GITHUB_TOKEN=${SECRET_TOKEN}

# Create the /opt/health-check directory and ensure permissions
sudo mkdir -p /opt/health-check
sudo chown -R $(whoami):$(whoami) /opt
sudo chmod -R 755 /opt

# Clone or update the repository
cd /opt
if [ ! -d "/opt/assignment-2-cloud-native-web-application-sagarikapandey17" ]; then
    git clone https://$GITHUB_TOKEN@github.com/sagarikapandey17/assignment-2-cloud-native-web-application-sagarikapandey17.git
else
    echo "Repository already exists, pulling latest changes..."
    cd /opt/assignment-2-cloud-native-web-application-sagarikapandey17
    git pull origin Assignment5
fi

# Checkout the correct branch
cd /opt/assignment-2-cloud-native-web-application-sagarikapandey17/health-check
git fetch --all
git checkout main

# Build the application with Maven
sudo mvn clean install

# Ensure the target directory and JAR file exist before attempting to copy
if [ -f "target/health-check-0.0.1-SNAPSHOT.jar" ]; then
    sudo cp target/health-check-0.0.1-SNAPSHOT.jar /opt/health-check/health-check.jar
else
    echo "Build failed, JAR file not found!"
    exit 1
fi


echo "Application deployment complete."
