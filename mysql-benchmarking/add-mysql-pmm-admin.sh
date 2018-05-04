#!/bin/bash

# Add mysql to pmm-admin
if [ "$1" != "" ]; then
    pmm-admin add mysql --user username --password password --host $1
else
    echo "Adding local mysql..."
    pmm-admin add mysql --user username --password password
fi