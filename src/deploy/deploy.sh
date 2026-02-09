#!/bin/bash

set -e

DEPLOY_SERVER_HOST="10.12.167.101"
DEPLOY_SERVER_USER="ubuntu"

mkdir -p ~/.ssh
cp src/deploy/deploy-key ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=accept-new $DEPLOY_SERVER_USER@$DEPLOY_SERVER_HOST "echo SSH connection established successfully!"
scp code-samples/DO $DEPLOY_SERVER_USER@$DEPLOY_SERVER_HOST:/tmp/DO
ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=accept-new $DEPLOY_SERVER_USER@$DEPLOY_SERVER_HOST "sudo mv /tmp/DO /usr/local/bin/DO && sudo chmod +x /usr/local/bin/DO && ls -la /usr/local/bin/DO"
