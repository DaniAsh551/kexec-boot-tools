# KEXEC BOOT TOOLS

## Structure
```
.                       -   Project Root
├── .env                -   ENV variables for build tasks (.gitignored)
├── .env.example        -   Example ENV variables for build tasks
├── build-bootimg.sh    -   Packs ramdisk and kernel to bootimg in out (Contains offset definitions)
├── build-init.sh       -   Builds init binary and copies it to out/initrd
├── build-ramdisk.sh    -   Builds ramdisk from out/initrd (NEEDS ROOT ACCESS but DO NOT run as root - it will ask for auth with sudo) 
├── build.sh            -   Run all build scripts in order
├── copy-initrd.sh      -   Copy src/initrd to out/initrd
├── kernel              -   Prebuilt kernel image with CONFIG_KEXEC (.gitignored)
├── out                 -   Build directory (.gitignored)
├── push-bootimg.sh     -   Push the built (PROMPT)bootimg and flash and (PROMPT)reboot.
├── README.md           -   This README file
└── src                 -   Source for everything needed for init (initrd,init,init.sh)
    ├── init.c          -   Source for custom init binary
    ├── initrd          -   Base initrd (put anything you need in ramdisk here)
    └── init.sh         -   Custom init shell (Executed in bash after prelim setup)
```

## Dependencies
* android-ndk
* cat
* xargs
* adb
* cpio
* gunzip

## Instructions
1. Install all dependencies (See previous section)
2. Set required ENV variables in `.env` (see `.env.example`)
3. Copy prebuilt kernel image to project root (`./kernel`)
4. Run `build.sh`
### Run any script here to repeat their respective step (See the Structure section)