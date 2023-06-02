Name: b20-515-10
Version:       1.0
Release:       1%{?dist}
Summary:       Mironova ilyi b20-515
Group:         Testing
License:       GPL
URL:           https://github.com/Millcool/OSSecMEPhi/tree/main/lab12
Source0:       %{name}-%{version}.tar.gz
BuildRequires: /bin/rm, /bin/mkdir, /bin/cp
Requires:      /bin/bi
BuildArch:     noarch

%description
A test package

%prep
%setup -q

%install
mkdir -p %{buildroot}%{_bindir}
install -m 755 b20-515-10 %{buildroot}%{_bindir}

%files
%{_bindir}/b20-515-10

%changelog 
* Thu Oct 16 2012 <Mironov>
- Added %{_bindir}/b20-515-10
