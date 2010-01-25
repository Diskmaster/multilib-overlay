# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libunique/libunique-1.0.8.ebuild,v 1.11 2009/08/28 12:24:34 klausman Exp $

EAPI="2"

inherit gnome2 virtualx multilib-native

DESCRIPTION="a library for writing single instance application"
HOMEPAGE="http://live.gnome.org/LibUnique"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="dbus doc introspection"

RDEPEND=">=dev-libs/glib-2.12.0[lib32?]
	>=x11-libs/gtk+-2.11.0[lib32?]
	x11-libs/libX11[lib32?]
	dbus? ( >=dev-libs/dbus-glib-0.70[lib32?] )
	introspection? (
		>=dev-libs/gobject-introspection-0.6.3[lib32?]
		dev-libs/gir-repository[gtk,lib32?] )"
DEPEND="${RDEPEND}
	sys-devel/gettext[lib32?]
	>=dev-util/pkgconfig-0.17[lib32?]
	doc? ( >=dev-util/gtk-doc-1.11 )"
# For eautoreconf
#	dev-util/gtk-doc-am

DOCS="AUTHORS NEWS ChangeLog README TODO"

multilib-native_pkg_setup_internal() {
	G2CONF="${G2CONF}
		--disable-maintainer-flags
		--disable-static
		--enable-bacon
		$(use_enable dbus)
		$(use_enable introspection)"
}

src_test() {
	cd "${S}/tests"

	# Fix environment variable leakage (due to `su` etc)
	unset DBUS_SESSION_BUS_ADDRESS

	# Force Xemake to use Xvfb, bug 279840
	unset XAUTHORITY

	cp "${FILESDIR}/run-tests" . || die "Unable to cp \${FILESDIR}/run-tests"
	Xemake -f run-tests || die "Tests failed"
}
