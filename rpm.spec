Name:       FClash
Version:    1.4.0
Release:    1
Summary:    A Clash Proxy Fronted based on Clash
License:    GPL-3
Requires:   gtk3 libappindicator-gtk3
Provides:   libproxy_manager_plugin.so()(64bit) libclash.so()(64bit) libflutter_linux_gtk.so()(64bit) libproxy_manager_plugin.so()(64bit) libscreen_retriever_plugin.so()(64bit) libtray_manager_plugin.so()(64bit) liburl_launcher_linux_plugin.so()(64bit) libwindow_manager_plugin.so()(64bit)

%description
A Clash Proxy Fronted based on Clash.

%prep
# we have no source, so nothing here

%build
# we build FClash beforehand
# bash ${FCLASH_SRC}/build-deb.sh

%install
bsdtar -zxvf ${FCLASH_SRC}/debian/cn.kingtous.fclash.deb
tar -xvf data.tar.xz
ls -l ./opt
mkdir -p "%{buildroot}"
mv "./opt"  "%{buildroot}/opt"
install -Dm0755 "${FCLASH_SRC}/debian/build-src/opt/apps/cn.kingtous.fclash/entries/applications/cn.kingtous.fclash.desktop" "%{buildroot}/usr/share/applications/cn.kingtous.fclash.desktop"

%files
/opt/*
/usr/share/applications/cn.kingtous.fclash.desktop

%changelog
# let's skip this for now