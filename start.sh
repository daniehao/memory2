#!/bin/bash

export MIX_ENV=prod
export PORT=4791

echo "Stopping old copy of app, if any..."

_build/prod/rel/draw/bin/practice stop || true

echo "Starting app..."

# TODO: You want start.

_build/prod/rel/draw/bin/practice foreground

# TODO: Add a cron rule or systemd service file
#       to start your app on system boot.

