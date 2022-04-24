#!/bin/bash

echo "Packaging the ramdisk"
sudo sh -c "cd $PWD/out/initrd;find . | cpio --create --format='newc' | gzip > ../ramdisk"
echo "Setting permissions on the built ramdisk"
sudo chmod 777 $PWD/out/ramdisk
