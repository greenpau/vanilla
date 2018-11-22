#!/usr/bin/env bash
set -e

# Enable for debuggin purposes only
[ "$DEBUG" == 'true' ] && set -x

if [ -z ${SSHD_PORT+x} ]; then SSHD_PORT="2222"; fi

if [ -z ${NOMAD_PORT_caddy+x} ]; then
  if [ -z ${CADDY_PORT+x} ]; then
    CADDY_PORT="2280"
  fi
else
  CADDY_PORT=${NOMAD_PORT_caddy}
fi

IFNAME=$(cat /proc/net/route | cut -f1,2 | grep 00000000 | cut -f1)
IPV4=$(ip addr show dev $IFNAME | grep "inet " | sed "s/.*inet //" | cut -d"/" -f1)
# configure ssh
ADMIN_USER=`whoami`
mkdir -p $HOME/.ssh
mv /app/id_rsa* $HOME/.ssh
cat $HOME/.ssh/*.pub > $HOME/.ssh/authorized_keys
chown -R $ADMIN_USER:$ADMIN_USER $HOME/.ssh
chmod 600 $HOME/.ssh/authorized_keys
tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1 | passwd $ADMIN_USER --stdin
mkdir -p /etc/ssh/
mv /app/ssh_host* /etc/ssh
chmod 600 /etc/ssh/*key
/usr/sbin/sshd -p ${SSHD_PORT}

# configure caddy
mkdir -p /etc/caddy
cat << EOF > /etc/caddy/Caddyfile
*:${CADDY_PORT} {
    root /var/lib/caddy
    index index.html
    tls off
}
*:80 {
    root /var/lib/caddy
    index index.html
    tls off
}
EOF
mkdir -p /var/lib/caddy
cat << EOF > /var/lib/caddy/index.html
<html>
    <head>
        <title>Caddy</title>
    </head>
    <body>
        <h1>Caddy</h1>
        <li>IPv4: ${IPV4}</li>
    </body>
</html>
EOF

echo "Running $@"
exec "$@"
