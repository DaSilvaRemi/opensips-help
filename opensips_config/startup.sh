#!/bin/sh

# Wait for MySQL to be ready
echo "Waiting for MySQL..."
until mysqladmin ping -h mysql -uroot -proot --silent; do
  sleep 2
done

# Try to create the DB (idempotent)
echo "Creating OpenSIPS DB if needed..."
opensips-cli -x database create || true

# Insert registrant data (if script exists)
if [ -f /etc/opensips/create_registrant.sql ]; then
  echo "Inserting SIP registrant..."
  # mysql -hmysql -uroot -proot opensips < /etc/opensips/create_registrant.sql
  envsubst < /etc/opensips/create_registrant.sql | mysql -hmysql -uroot -proot opensips
else
  echo "Registrant SQL file not found: skipping."
fi

# Start rtpproxy
echo "Starting RTPProxy..."
if [ ! -d /var/run/rtpproxy ]; then
  mkdir -p /var/run/rtpproxy
  echo "Created RTPProxy directory"
  chown rtpproxy:rtpproxy /var/run/rtpproxy
fi
/usr/local/bin/rtpproxy -p /var/run/rtpproxy/rtpproxy.pid -s unix:/var/run/rtpproxy/rtpproxy.sock -u rtpproxy:rtpproxy -n unix:/var/run/rtpproxy/rtpproxy_timeout.sock -f -L 4096 -l [OPENSIPS_PUBLIC_IP] -m 10000 -M 10005 -d INFO:LOG_LOCAL5 &
echo "Waiting for RTPProxy to start..."
until [ -S /var/run/rtpproxy/rtpproxy.sock ]; do
  sleep 2
done
echo "RTPProxy started."

# Start OpenSIPS in foreground
echo "Starting OpenSIPS..."
exec /usr/sbin/opensips -F
