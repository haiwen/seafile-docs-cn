#!/bin/bash

set -e

if [[ $DEPLOY_USER == "" || $DEPLOY_SERVER == "" || $DEPLOY_CMD == "" ]]; then
    echo "Not configured properly."
    exit 1
fi

if [[ $TRAVIS_BRANCH != "master" ]]; then
    exit 0
fi

mkdir -p ~/.ssh
cat >~/.ssh/config <<EOF
Host *
     UserKnownHostsFile /dev/null
     StrictHostKeyChecking no
EOF

openssl aes-256-cbc -K $encrypted_392ef5b5fe82_key -iv $encrypted_392ef5b5fe82_iv -in scripts/key.txt.enc -out ~/.ssh/id_rsa -d
chmod 400 ~/.ssh/id_rsa

if ! ssh $DEPLOY_USER@$DEPLOY_SERVER $DEPLOY_CMD seafile-docs-cn; then
    echo "Failed to deploy"
    exit 1
fi
