# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libsoup-gnome/libsoup-gnome-2.30.1.ebuild,v 1.3 2010/06/16 18:18:39 pacho Exp $

EAPI="2"

inherit autotools eutils gnome2 multilib-native

MY_PN=${PN/-gnome}
MY_P=${MY_PN}-${PV}

DESCRIPTION="GNOME plugin for libsoup"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${SRC_URI//-gnome}"

LICENSE="LGPL-2"
SLOT="2.4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-solaris"
# Do NOT build with --disable-debug/--enable-debug=no - gnome2.eclass takes care of that
IUSE="debug doc"

RDEPEND="~net-libs/libsoup-${PV}[lib32?]
	|| ( gnome-base/libgnome-keyring[lib32?] <gnome-base/gnome-keyring-2.29.4[lib32?] )
	net-libs/libproxy[lib32?]
	>=gnome-base/gconf-2[lib32?]
	dev-db/sqlite:3[lib32?]"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9[lib32?]
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS NEWS README"

multilib-native_pkg_setup_internal() {
	G2CONF="${G2CONF}
		--disable-static
		--with-libsoup-system
		--with-gnome"
}
multilib-native_src_prepare_internal() {
	gnome2_src_prepare

	# Fix test to follow POSIX (for x86-fbsd)
	# No patch to prevent having to eautoreconf
	sed -e 's/\(test.*\)==/\1=/g' -i configure.ac configure || die "sed failed"

	# Use lib present on the system
	epatch "${FILESDIR}"/${PN}-2.30.1-system-lib.patch
	eautoreconf
}
