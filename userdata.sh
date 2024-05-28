#!/bin/bash
# Update the package list
sudo yum update -y

# Install MongoDB
sudo tee /etc/yum.repos.d/mongodb-org-4.4.repo <<EOL
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOL

sudo yum install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Wait for MongoDB to start
sleep 10

# Configure MongoDB replica set
if [ ${instance_number} -eq 1 ]; then
  mongo --eval 'rs.initiate()'
  sleep 10
  mongo --eval 'rs.add("mongo2:27017")'
  mongo --eval 'rs.add("mongo3:27017")'
fi
