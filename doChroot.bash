#!/bin/bash

pushd $(dirname $0)

sudo bash -c 'grep -e "nameserver" /etc/resolv.conf >> iso-modified/etc/resolv.conf'
sudo mount --bind /dev/ iso-modified/dev
sudo cp ./{setup,cleanup}InsideChroot.bash iso-modified/
sudo cp ./insideChrootActions.bash ./iso-modified/
sudo cp -a ./custom ./iso-modified/
sudo chmod +x iso-modified/{setup,cleanup}InsideChroot.bash iso-modified/insideChrootActions.bash
sudo chroot iso-modified ./setupInsideChroot.bash
sudo chroot iso-modified bash
sudo chroot iso-modified ./cleanupInsideChroot.bash
sudo umount iso-modified/dev
sudo rm -r iso-modified/{setup,cleanup}InsideChroot.bash iso-modified/insideChrootActions.bash iso-modified/custom

popd

