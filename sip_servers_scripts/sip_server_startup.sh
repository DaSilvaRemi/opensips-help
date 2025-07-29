#!/bin/bash

# Wait for MySQL to be ready
echo "Waiting for MySQL..."
until mysqladmin ping -h mysql -uroot -proot --silent; do
  sleep 2
done

# Add to database
if [ -f /app/sip_servers_scripts/insert_in_load_balancer.sql ]; then
  echo "Inserting current SIP server in opensips database..."
  envsubst < /app/sip_servers_scripts/insert_in_load_balancer.sql | mysql -hmysql -uroot -proot opensips
else
  echo "Database insertion SQL file not found: skipping."
fi

# Refresh OpenSIPS load balancer
curl -X POST http://opensips:8888/mi -H "Content-Type: application/json" -d "{\"jsonrpc\":\"2.0\",\"method\":\"lb_reload\",\"id\":10}"

# Start SipServer in foreground
echo "Starting SipServer..."
python Phone.py