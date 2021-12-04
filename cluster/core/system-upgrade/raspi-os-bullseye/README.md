# raspi-os bullseye upgrade with rancher system-upgrade-controller

## label nodes for upgrade manually
```sh
// example: kubectl label node <node-name> plan.upgrade.cattle.io/raspi-os=true
kubectl label node pi-node01 plan.upgrade.cattle.io/raspi-os=true
kubectl label node pi-node02 plan.upgrade.cattle.io/raspi-os=true
kubectl label node pi-node03 plan.upgrade.cattle.io/raspi-os=true
```

## shell script from secret

```bash
#!/bin/bash
set -e
LOCK_FILE="/tmp/system-upgrade-raspi-os-bullseye.lock"
if [ -f $LOCK_FILE ]; then
  echo "system upgrade is locked, maybe running or failed?"
  echo "to unlock delete $LOCK_FILE"
  sleep 60
  exit 1
fi
echo "1" > $LOCK_FILE
VERSION=$(cat /etc/debian_version)
# only upgrade from 10.11
if [ ! $VERSION == "10.11" ]; then
  if [ $VERSION == "11.1" ]; then
    echo "update successfull version is $VERSION"
    rm $LOCK_FILE
    exit 0
  fi
  echo "current version = $VERSION, no update possible."
  rm $LOCK_FILE
  exit 0
fi
export DEBIAN_FRONTEND=noninteractive
apt --assume-yes update
apt --assume-yes dist-upgrade
yes | rpi-update
sed 's/buster/bullseye/g' /etc/apt/sources.list > /etc/apt/sources.list.bullseye
mv /etc/apt/sources.list /etc/apt/sources.list.buster
mv /etc/apt/sources.list.bullseye /etc/apt/sources.list
apt --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" update
apt --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt --assume-yes autoclean
if [ -f /var/run/reboot-required ]; then
  echo "reboot required"
  reboot
else
  echo "no reboot required"
  rm $LOCK_FILE
fi
```
