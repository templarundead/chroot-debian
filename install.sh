#!/bin/sh

if [ -z $(nvram get help_enable) ] ; then
    echo 'It works on Padavan firmware only, sorry. Exiting...'
    exit 1
fi

dl () {
    # $1 - URL to download
    # $2 - place to store
    # $3 - 'x' if should be executable
    echo -n "Downloading $2... "
    wget -q --no-check-certificate $1 -O $2
    if [ $? -eq 0 ] ; then
	echo 'success!'
    else
	echo 'failed!'
    exit 1
    fi
    [ -z "$3" ] || chmod +x $2
}

cd /opt

if [ ! -e '/opt/bin/opkg' ] ; then
    # Entware is not installed, install start scripts
    mkdir -p /opt/etc/init.d
    dl http://pkg.entware.net/binaries/mipsel/installer/rc.func /opt/etc/init.d/rc.func
    dl http://pkg.entware.net/binaries/mipsel/installer/rc.unslung /opt/etc/init.d/rc.unslung x
    sed -i 's|/opt/bin/find|find|g' /opt/etc/init.d/rc.unslung
    # This prevents f\w to install Entware
    mkdir -p /opt/bin
    touch /opt/bin/opkg
fi

dl https://raw.githubusercontent.com/DontBeAPadavan/chroot-debian/master/opt/etc/init.d/S99debian /opt/etc/init.d/S99debian x
dl https://github.com/templarundead/chroot-debian/raw/master/debian-stable-mipsel.tgz /opt/debian-stable-mipsel.tgz

echo -n 'Unpacking Debian environment... '
tar -xzf debian-stable-mipsel.tgz
if [ $? -eq 0 ] ; then
    echo 'success!'
else
    echo 'failed!'
    exit 1
fi
rm debian-stable-mipsel.tgz
echo 'ssh' > /opt/debian/chroot-services.list

echo -n 'The Debian services from /opt/debian/chroot-services.list will be started automatically at boot time. You may log into Debian environment via SSH root:debian@192.168.0.1:65022. Do you wish to start it now? [y/n]: '
read yn
[ "$yn" = "y" ] && /opt/etc/init.d/S99debian start
