#!/bin/bash

echo "Creating Database $PGDATABASE"

if [ "$PGPASS" != "" ]; then
  echo "*:*:*:$PGUSER:$PGPASS" > ~/.pgpass
  chmod 600 ~/.pgpass
  export PGPASSFILE=~/.pgpass
fi

createdb

echo "Database $PGDATABASE created"

exit 0
