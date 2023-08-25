#!/bin/sh

cat << EOF
===
This script installs and reloads the pf(4)
configuration for lab-bc machines. Please
enter the daemon that you are going to use
with this machine (either 'bundled', 'relayd',
or 'workerd')
===
EOF

echo -n "Daemon name: "
read daemon

file=$daemon.conf
if [ ! -r $file ]; then
	echo "invalid daemon $daemon"
	exit 1
fi

doas cp $daemon.conf /etc/pf.conf
doas chown root:wheel /etc/pf.conf
doas chmod 600 /etc/pf.conf
doas pfctl -f /etc/pf.conf

if [ "$daemon" != "bundled" ]; then
	doas sysctl net.inet.ip.forwarding=1
	cat << EOF
===
please add the packet forwarding sysctl to your
/etc/sysctl.conf. The relevant line that should be
in there is:

net.inet.ip.forwarding=1

if you haven't touched /etc/sysctl.conf and want
a one liner, this will work:

doas sh -c "echo 'net.inet.ip.forwarding=1' >> /etc/sysctl.conf"
===
EOF
fi
