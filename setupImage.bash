#!/bin/bash

isoFile=$(readlink -f $1)

pushd $(dirname $0)
	
mkdir iso-mount
sudo mount -o loop $isoFile iso-mount
mkdir iso-extract
sudo rsync --exclude=/casper/filesystem.squashfs -a iso-mount/ iso-extract

popd

sudo unsquashfs iso-mount/casper/filesystem.squashfs
sudo mv squashfs-root iso-modified
