#!/bin/busybox ash


BB=/bin/busybox
DATA="/data"

export PATH="/bin"

function printk() {
    if [ -f /dev/kmsg ]; then
        echo "[KBT] $@" > /dev/kmsg
    else
        echo "[KBT] $@"
    fi
}

# if [ -d $DATA ]; then
#     echo "$DATA exists" > /dev/kmsg
# else
#     echo "$DATA DOES NOT exist" > /dev/kmsg
# fi

# if [ -f $DATA/rootfs.img ]; then
#     echo "$DATA/rootfs.img exists" > /dev/kmsg
# else
#     echo "$DATA/rootfs.img DOES NOT exist" > /dev/kmsg
# fi

# echo "KEXEC_TOOLS Mounting $DATA/rootfs.img on /root" > /dev/kmsg
# mount $DATA/rootfs.img /root 2>&1> /dev/kmsg

# echo "KEXEC_TOOLS Listing /system" > /dev/kmsg
# for e in /system/*; do
#     echo "KEXEC_TOOLS $e" > /dev/kmsg
# done

# printk "Mounting /system"
# printk "$(mount -t ext4 -o rw,seclabel,relatime,block_validity,delalloc,barrier,user_xattr,acl /dev/sda25 /system)"

# printk "Moving to /root" 
# printk "$(mount --move /sys /system)"
# printk "$(mount --move /dev /system)"
# printk "$(mount --move /proc /system)"

# echo "KEXEC_TOOLS Handing over to /sbin/init" > /dev/kmsg
# pivot_root /system /sbin/init

printk "[KBT] Hello from KEXEC_BOOT_TOOLS sh"
printk "[KBT] EXECUTE /init_real"

/init_real>/dev/kmsg