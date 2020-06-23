Name:       nemo-device-config-virtualbox
Summary:    Config files for VirtualBox
Version:    0.1
Release:    0
BuildArch:  noarch
Group:      System/Base
License:    MIT
URL:        https://github.com/rinigus/nemo-device-config-virtualbox
Source0:    %{name}-%{version}.tar.bz2

Requires:  mesa-dri-swrast-driver
Requires:  mesa-libEGL
Requires:  mesa-libGLESv2
Requires:  mesa-libgbm
Requires:  mesa-libglapi

Requires:  qt5-plugin-platform-eglfs
Requires:  qt5-plugin-generic-vboxtouch

Requires:  kernel-adaptation-pc
Requires:  linux-firmware
Requires:  installer-shell

Requires:  sensorfw-qt5 >= 0.11.4

#provide services for startup user session
Requires:   systemd-config-mer
Requires:   nemo-mobile-session-common

#provide keyboard
Requires:   maliit-plugins

# WiFi/BT regulator DB

%description
This package contains the config files for
VirtualBox.

%prep
%setup -q -n %{name}-%{version}

%build

%install
mkdir -p $RPM_BUILD_ROOT
rm -rf tmp/
mkdir -p tmp/

#create list of files
echo "%defattr(-,root,root,-)" > tmp/sparse.files
cd sparse/
find . \( -type f -o -type l \) -print | sed 's/^.//' | sed 's/\/etc/%config \/etc/g' > ../tmp/sparse.files
cd ../

#sparce copy
cp -r sparse/* $RPM_BUILD_ROOT/

%files -f tmp/sparse.files
%defattr(-,root,root,-)
