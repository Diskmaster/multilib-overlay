# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libnotify/libnotify-0.4.5.ebuild,v 1.14 2010/03/26 16:28:15 ssuominen Exp $

EAPI=2

inherit multilib-native

DESCRIPTION="Notifications library"
HOMEPAGE="http://www.galago-project.org/"
SRC_URI="http://www.galago-project.org/files/releases/source/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6:2[lib32?]
	>=dev-libs/glib-2.6:2[lib32?]
	>=dev-libs/dbus-glib-0.76[lib32?]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig[lib32?]"
PDEPEND="|| ( x11-misc/notification-daemon[lib32?]
	xfce-extra/xfce4-notifyd )"

multilib-native_src_configure_internal() {
	econf \
		--disable-dependency-tracking
}

multilib-native_src_install_internal() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS
}
