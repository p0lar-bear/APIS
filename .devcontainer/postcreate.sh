#! /usr/bin/env bash

THISUSER=$(id -u)
THISGROUP=$(id -g)

# Install frontend dependencies and build
cd /apis/registration/frontend
echo "chown-ing node_modules $THISUSER:$THISGROUP"
sudo chown $THISUSER:$THISGROUP node_modules
echo "Building frontend..."
npm install
npm run build

# Install python dependencies
cd /apis
echo "chown-ing .venv to $THISUSER:$THISGROUP"
sudo chown $THISUSER:$THISGROUP .venv
echo "Resolving uv dependencies..."
uv sync

# Copy the devcontainer settings boilerplate
if [ ! -f ./fm_eventmanager/settings.py ]
cp ./.devcontainer/settings.py.devcontainer ./fm_eventmanager/settings.py

# Set up the database schema
echo "Running database migrations..."
uv run manage.py migrate
