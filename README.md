# Debian chroot environment

This scripts helps to install Debian 8 services on MIPS routers with [Padavan firmware](https://bitbucket.org/padavan/rt-n56u).


## Prerequisites

Prepare Ext2/Ext3/Ext4 partition on USB drive by following [this manual](https://bitbucket.org/padavan/rt-n56u/wiki/EN/HowToConfigureEntware). 
Clean Debian environment takes ~300MB. SWAP usage is also recommended (especially on 64MB RAM devices).

## Installation

It takes few minutes to download and unpack ~50MB archive. Log into router's SSH/telnet/serial console and type:
```
wget https://raw.githubusercontent.com/ryzhovau/padavan-debian/master/install.sh
sh install.sh
```
If all goes as expected, you'll get:
```
Downloading /opt/etc/init.d/rc.func... success!
Downloading /opt/etc/init.d/rc.unslung... success!
Downloading /opt/etc/init.d/S99debian... success!
Downloading /opt/debian_clean.tgz... success!
Unpacking Debian environment... success!
The Debian services from /opt/debian/chroot-services.list will be started automatically at boot time. You may log into Debian environment via SSH root:debian@192.168.0.1:65022. Do you wish to start it now? [y/n]: y
Starting Debian services...
[ ok ] Starting OpenBSD Secure Shell server: sshd.
Done.
```


## Usage

Log into chroot'ed Debian environment by `root:debian@192.168.0.1:65022` where `192.168.0.1` is the IP address of router. You've got full blown Debian on board with all it's 40+ thousands packages! Let's install transmission as an example:
```
apt-get update
apt-get install transmission-daemon
echo 'transmission-daemon' > /chroot-services.list
```
The last command adds transmssion to the list of Debian services, which is started at boot time. `transmission-daemon` is the script name from `/etc/init.d/<name>`.

This is just a sandbox, which is isolated from host system. If you'll break it, you can always start from scratch. Log into router console and run:
```
cd /opt
/opt/etc/init.d/S99debian stop
rm -fr debian
rm /opt/etc/init.d/S99debian
sh install.sh
```
Voilà! You've got fresh Debian installation again.


## Details

The installation script unpacks prepared Debian environment. You can prepare it manually, [see how](https://github.com/ryzhovau/padavan-debian/blob/master/prepare-env.txt). 

Also, take a look at `/opt/etc/init.d/S99debian`. You can mount any host folder as `/media` in Debian env. by setting `$EXT_DIR` varialble. It's a "bridge" between host and chroot'ed systems. 

Good luck!
