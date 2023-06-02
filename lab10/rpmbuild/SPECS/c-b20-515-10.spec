Name: c-b20-515-10
Version:       1.0
Release:       1%{?dist}
Summary:       Mironova ilyi b20-515
Group:         Testing
License:       GPL
URL:           https://github.com/Millcool/OSSecMEPhi/tree/main/lab12
Source0:       %{name}-%{version}.tar.gz
BuildRequires: gcc

%description
A test package

%prep
%setup -q

%build
gcc -O2 -o c-b20-515-10 c-b20-515-10.c

%install
mkdir -p %{buildroot}%{_bindir}
cp c-b20-515-10 %{buildroot}%{_bindir}

%files
%{_bindir}/c-b20-515-10

%changelog 
* Thu Oct 16 2023 ILYA MIRONOV <Mironov>
- Added %{_bindir}/c-b20-515-10
