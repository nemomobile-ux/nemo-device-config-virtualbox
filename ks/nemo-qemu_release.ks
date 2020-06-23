# DisplayName: GlacierUX/i486 (release) 2020.05
# KickstartType: release
# SuggestedImageType: fs
# SuggestedArchitecture: i486

lang en_US.UTF-8
keyboard us
user --name nemo --groups audio,video --password nemo
timezone --utc UTC

### Commands from /tmp/sandbox/usr/share/ssu/kickstart/part/default
part / --size 1200 --ondisk sda --fstype=ext4

## No suitable configuration found in /tmp/sandbox/usr/share/ssu/kickstart/bootloader

repo --name=mer-core --baseurl=http://repo.merproject.org/obs/home:/neochapay:/mer:/release:/2020.05:/core/latest_i486
repo --name=mer-qt --baseurl=http://repo.merproject.org/obs/home:/neochapay:/mer:/release:/2020.05:/qt/latest_i486
repo --name=mer-mw --baseurl=http://repo.merproject.org/obs/home:/neochapay:/mer:/release:/2020.05:/mw/latest_i486
repo --name=nemo-ux --baseurl=http://repo.merproject.org/obs/home:/neochapay:/mer:/release:/2020.05:/ux/latest_i486
repo --name=tools --baseurl=http://repo.merproject.org/obs/home:/neochapay:/mer:/release:/2020.05:/tools/latest_i486

repo --name=x86 --baseurl=http://repo.merproject.org/obs/home:/neochapay:/mer:/release:/2020.05:/hardware:/x86/latest_i486
repo --name=x86-tmp --baseurl=http://repo.merproject.org/obs/home:/rinigus:/sandbox-x86/latest_i486/

%packages
#if you have modules
module-init-tools
procps

#this packages must be added into requires
qt5-qtfeedback #BUG glacier-home #91
kf5bluezqt-bluez5-declarative #BUG glacier-serrings #16

#master packages
lipstick-glacier-home-qt5
glacier-calc
glacier-camera
glacier-contacts
#glacier-dialer
glacier-filemuncher
glacier-gallery
glacier-music
glacier-settings

nemo-firstsession
nemo-mobile-session-wayland

#dev packages
passwd
vim
setup
strace
gdb
zypper

#just for test
qt5-plugin-platform-eglfs
qt5-plugin-platform-linuxfb
qt5-plugin-platform-minimal
# qt5-plugin-platform-offscreen
# qtdeclarative-render2d

#PinePhone64 packages
# mesa-llvmpipe-dri-lima-driver
# mesa-llvmpipe-dri-swrast-driver
# mesa-llvmpipe-dri-sun4i-driver

nemo-device-config-virtualbox

#kernel-adaptation-pc
#linux-firmware
#installer-shell

virtualbox-guest-tools
virtualbox-guest-modules

#mesa-dri-swrast-driver
#mesa-libEGL
#mesa-libGLESv2
#mesa-libgbm
#mesa-libglapi

#qt5-plugin-generic-vboxtouch

openssh-server
#openssh

%end
%pre
export SSU_RELEASE_TYPE=release
### begin 01_init
touch $INSTALL_ROOT/.bootstrap
### end 01_init
%end

%post
export SSU_RELEASE_TYPE=release
### begin 01_arch-hack
# Without this line the rpm does not get the architecture right.
echo -n "i486-meego-linux" > /etc/rpm/platform

# Also libzypp has problems in autodetecting the architecture so we force tha as well.
# https://bugs.meego.com/show_bug.cgi?id=11484
echo "arch = i486" >> /etc/zypp/zypp.conf

#add repos 
zypper ar -G http://repo.merproject.org/obs/home:/neochapay:/mer:/release:/2020.05:/core/latest_i486 mer-core
zypper ar -G http://repo.merproject.org/obs/home:/neochapay:/mer:/release:/2020.05:/mw/latest_i486 mer-mw
zypper ar -G http://repo.merproject.org/obs/home:/neochapay:/mer:/release:/2020.05:/qt/latest_i486 mer-qt
zypper ar -G http://repo.merproject.org/obs/home:/neochapay:/mer:/release:/2020.05:/ux/latest_i486 nemo-ux

### end 01_arch-hack
### begin 01_rpm-rebuilddb
# Rebuild db using target's rpm
echo -n "Rebuilding db using target rpm.."
rm -f /var/lib/rpm/__db*
rpm --rebuilddb
echo "done"
### end 01_rpm-rebuilddb
### begin 50_oneshot
# exit boostrap mode
rm -f /.bootstrap

# export some important variables until there's a better solution
export LANG=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
export GSETTINGS_BACKEND=gconf

# run the oneshot triggers for root and first user uid
UID_MIN=$(grep "^UID_MIN" /etc/login.defs |  tr -s " " | cut -d " " -f2)
DEVICEUSER=`getent passwd $UID_MIN | sed 's/:.*//'`

if [ -x /usr/bin/oneshot ]; then
   su -c "/usr/bin/oneshot --mic"
   su -c "/usr/bin/oneshot --mic" $DEVICEUSER
fi
### end 50_oneshot
### begin 60_ssu

sed -i "s|$EXPLICIT_BUSYBOX telnetd|#EXPLICIT_BUSYBOX telnetd|g" /init-debug
chown -R radio:radio /var/lib/ofono

### end 60_ssu
### begin 70_sdk-domain

export SSU_DOMAIN=@RNDFLAVOUR@

if [ "$SSU_RELEASE_TYPE" = "release" ] && [[ "$SSU_DOMAIN" = "public-sdk" ]];
then
    ssu domain sailfish
fi
### end 70_sdk-domain
%end

%post --nochroot
export SSU_RELEASE_TYPE=release
### begin 01_release
if [ -n "$IMG_NAME" ]; then
    echo "BUILD: $IMG_NAME" >> $INSTALL_ROOT/etc/meego-release
fi

%end

%pack
export SSU_RELEASE_TYPE=release
%end
