#!/bin/bash

set -e

if [ -f /etc/configured ]; then
    echo 'Locale already configured'
else
    # Needed for fix problem with ubuntu and cron
    update-locale 
    date > /etc/configured
fi
