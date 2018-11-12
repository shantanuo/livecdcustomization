#!/bin/bash

if [ -z "$1" ]; then echo "No filename specified"; exit; fi

pushd $(dirname $0)

sudo chmod +w iso-extract/casper/filesystem.manifest
sudo bash -c "chroot iso-modified dpkg-query -W --showformat='\${Package} \${Version}\n' > iso-extract/casper/filesystem.manifest"
sudo cp iso-extract/casper/filesystem.manifest iso-extract/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' iso-extract/casper/filesystem.manifest-desktop
sudo sed -i '/casper/d' iso-extract/casper/filesystem.manifest-desktop
sudo rm iso-extract/casper/filesystem.squashfs
sudo mksquashfs iso-modified iso-extract/casper/filesystem.squashfs -comp xz -e iso-modified/boot
#sudo mksquashfs iso-modified iso-extract/casper/filesystem.squashfs
printf $(sudo du -sx --block-size=1 iso-modified | cut -f1) | sudo tee iso-extract/casper/filesystem.size > /dev/null

pushd iso-extract

sudo rm md5sum.txt
find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sum.txt
sudo mkisofs -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../$1 .

popd
popd
