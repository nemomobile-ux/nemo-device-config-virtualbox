Name:       nemo-device-config-virtualbox
Summary:    Config files for VirtualBox
Version:    0.1
Release:    0
BuildArch:  noarch
Group:      System/Base
License:    MIT
URL:        https://github.com/rinigus/nemo-device-config-virtualbox
Source0:    %{name}-%{version}.tar.bz2

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
