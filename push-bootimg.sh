#!/bin/bash

echo "Pushing kexec_boot.img to device (/tmp)"
adb shell "rm /tmp/kexec_boot.img" || true
adb push out/kexec_boot.img /tmp || exit 1

echo "Would you like to flash the boot img?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit 1;;
    esac
done

echo "Flashing kexec_boot.img to device"
adb shell 'su -c "dd if=/tmp/kexec_boot.img of=/dev/block/by-name/boot"' || adb shell 'sh -c "dd if=/tmp/kexec_boot.img of=$(ls /dev/block/platform/*/by-name/boot)"' || exit  1

echo "Flashing done. Would you like to reboot?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit 1;;
    esac
done

adb reboot
echo "Device reboot issued"