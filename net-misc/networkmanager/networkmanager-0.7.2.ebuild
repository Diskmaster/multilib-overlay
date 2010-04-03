# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/networkmanager/networkmanager-0.7.2.ebuild,v 1.5 2010/01/22 19:19:21 ranger Exp $

EAPI="2"
inherit eutils multilib-native
# autotools

#PATCH_VERSION="1b"

# NetworkManager likes itself with capital letters
MY_PN=${PN/networkmanager/NetworkManager}
MY_P=${MY_PN}-${PV}
#PATCHNAME="${MY_P}-gentoo-patches-${PATCH_VERSION}"

DESCRIPTION="Network configuration and management in an easy way. Desktop environment independent."
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"
SRC_URI="mirror://gnome/sources/NetworkManager/0.7/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="avahi doc nss gnutls dhclient dhcpcd resolvconf connection-sharing"
# modemmanager"

RDEPEND=">=sys-apps/dbus-1.2[lib32?]
	>=dev-libs/dbus-glib-0.75[lib32?]
	>=sys-apps/hal-0.5.10[lib32?]
	>=net-wireless/wireless-tools-28_pre9
	>=dev-libs/glib-2.16[lib32?]
	sys-auth/policykit[lib32?]
	>=dev-libs/libnl-1.1[lib32?]
	>=net-wireless/wpa_supplicant-0.5.10[dbus]
	|| ( sys-libs/e2fsprogs-libs[lib32?] <sys-fs/e2fsprogs-1.41.0[lib32?] )
	avahi? ( net-dns/avahi[autoipd,lib32?] )
	gnutls? (
		nss? ( >=dev-libs/nss-3.11[lib32?] )
		!nss? ( dev-libs/libgcrypt[lib32?]
			net-libs/gnutls[lib32?] ) )
	!gnutls? ( >=dev-libs/nss-3.11[lib32?] )
	dhclient? (
		dhcpcd? ( >=net-misc/dhcpcd-4.0.0_rc3 )
		!dhcpcd? ( >=net-misc/dhcp-3.0.0 ) )
	!dhclient? ( >=net-misc/dhcpcd-4.0.0_rc3 )
	resolvconf? ( net-dns/openresolv )
	connection-sharing? (
		net-dns/dnsmasq
		net-firewall/iptables )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig[lib32?]
	dev-util/intltool
	net-dialup/ppp
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.8 )"

#PDEPEND="modemmanager? ( >=net-misc/modemmanager-0.2 )"

S=${WORKDIR}/${MY_P}

multilib-native_src_prepare_internal() {

	# Fix up the dbus conf file to use plugdev group
	epatch "${FILESDIR}/${PN}-0.7.1-confchanges.patch"

}

multilib-native_src_configure_internal() {
	ECONF="--disable-more-warnings
		--localstatedir=/var
		--with-distro=gentoo
		--with-dbus-sys-dir=/etc/dbus-1/system.d
		$(use_enable doc gtk-doc)
		$(use_with doc docs)
		$(use_with resolvconf)"

	# default is dhcpcd (if none or both are specified), ISC dchclient otherwise
	if use dhclient ; then
		if use dhcpcd ; then
			ECONF="${ECONF} --with-dhcp-client=dhcpcd"
		else
			ECONF="${ECONF} --with-dhcp-client=dhclient"
		fi
	else
		ECONF="${ECONF} --with-dhcp-client=dhcpcd"
	fi

	# default is NSS (if none or both are specified), GnuTLS otherwise
	if use gnutls ; then
		if use nss ; then
			ECONF="${ECONF} --with-crypto=nss"
		else
			ECONF="${ECONF} --with-crypto=gnutls"
		fi
	else
		ECONF="${ECONF} --with-crypto=nss"
	fi

	econf ${ECONF}
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Need to keep the /var/run/NetworkManager directory
	keepdir /var/run/NetworkManager

	# Need to keep the /etc/NetworkManager/dispatched.d for dispatcher scripts
	keepdir /etc/NetworkManager/dispatcher.d

	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"

	# Add keyfile plugin support
	keepdir /etc/NetworkManager/system-connections
	insinto /etc/NetworkManager
	newins "${FILESDIR}/nm-system-settings.conf" nm-system-settings.conf \
		|| die "newins failed"
	insinto /etc/udev/rules.d
	newins callouts/77-nm-probe-modem-capabilities.rules 77-nm-probe-modem-capabilities.rules
	rm -rf "${D}"/lib/udev/rules.d
}

multilib-native_pkg_postinst_internal() {
	elog "You will need to restart DBUS if this is your first time"
	elog "installing NetworkManager."
	elog ""
	elog "To save system-wide settings as a user, that user needs to have the"
	elog "right policykit privileges. You can add them by running:"
	elog 'polkit-auth --grant org.freedesktop.network-manager-settings.system.modify --user "USERNAME"'
}
