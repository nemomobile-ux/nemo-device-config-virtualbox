# Nemo Configs for VirtualBox image

WIP - not working, in bootloop and lipstick crashes with segfault.

The current KS is added under ks subfolder and will be removed in future.

To generate image, run

```
sudo mic create raw --arch=i486 --tokenmap=ARCH:i486,RELEASE:2020.05 nemo-qemu_release.ks
```

and convert it using

```
VBoxManage convertdd nemo-qemu_release-sda.raw nemo-qemu_release-sdb.vdi --format VDI
```

Next, create VirtualBox machine and attach created
nemo-qemu_release-sdb.vdi as a storage via SATA controller. Let the
virtual machine use 128MB RAM for video, 2048MB RAM for memory.

Before starting, assuming that machine was called Nemo, run

```
VBoxManage setextradata "Nemo" CustomVideoMode1 540x960x32
VBoxManage setextradata "Nemo" GUI/AutoresizeGuest false
VBoxManage setextradata "Nemo" GUI/LastGuestSizeHint 536,960
VBoxManage setextradata "Nemo" GUI/InformationWindowGeometry 338,461,845,466
```

After that, start the machine.