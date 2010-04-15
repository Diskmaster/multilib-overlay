# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libproxy/libproxy-0.2.3-r3.ebuild,v 1.2 2010/04/13 21:39:06 hwoarang Exp $

EAPI="2"

inherit autotools eutils python portability multilib-native

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="http://code.google.com/p/libproxy/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="gnome kde networkmanager python webkit xulrunner"

RDEPEND="
	gnome? (
		x11-libs/libX11[lib32?]
		x11-libs/libXmu[lib32?]
		gnome-base/gconf[lib32?] )
	kde? (
		x11-libs/libX11[lib32?]
		x11-libs/libXmu[lib32?] )
	networkmanager? ( net-misc/networkmanager[lib32?] )
	python? ( >=dev-lang/python-2.5[lib32?] )
	webkit? ( net-libs/webkit-gtk[lib32?] )
	xulrunner? ( >=net-libs/xulrunner-1.9.0.11-r1:1.9[lib32?] )
"
# Since xulrunner-1.9.0.11-r1 its shipped mozilla-js.pc is fixed so we can use it

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19[lib32?]"

multilib-native_src_prepare_internal() {
	# http://code.google.com/p/libproxy/issues/detail?id=23
	epatch "${FILESDIR}/${P}-fix-dbus-includes.patch"

	# http://code.google.com/p/libproxy/issues/detail?id=24
	epatch "${FILESDIR}/${P}-fix-python-automagic.patch"

	# http://code.google.com/p/libproxy/issues/detail?id=25
	epatch "${FILESDIR}/${P}-fix-as-needed-problem.patch"

	# Bug 275127 and 275318
	epatch "${FILESDIR}/${P}-fix-automagic-mozjs.patch"

	# Fix implicit declaration QA, bug #268546
	epatch "${FILESDIR}/${P}-implicit-declaration.patch"

	epatch "${FILESDIR}/${P}-fbsd.patch" # drop at next bump

	# Fix test to follow POSIX (for x86-fbsd).
	# FIXME: This doesn't actually fix all == instances when two are on the same line
	sed -e 's/\(test.*\)==/\1=/g' -i configure.ac configure || die "sed failed"

	eautoreconf
}

multilib-native_src_configure_internal() {
	local myconf

	# xulrunner:1.9 => mozilla;
	# xulrunner:1.8 => xulrunner; (firefox => mozilla-firefox[-xulrunner] ?)
	if use xulrunner; then myconf="--with-mozjs=mozilla"
	else myconf="--without-mozjs"
	fi

	econf --with-envvar \
		--with-file \
		--disable-static \
		$(use_with gnome) \
		$(use_with kde) \
		$(use_with webkit) \
		${myconf} \
		$(use_with networkmanager) \
		$(use_with python)
}

multilib-native_src_compile_internal() {
	emake LIBDL="$(dlopen_lib)" || die
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" LIBDL="$(dlopen_lib)" install || die "emake install failed!"
	dodoc AUTHORS NEWS README ChangeLog || die "dodoc failed"
}

multilib-native_pkg_postinst_internal() {
	if use python; then
		python_need_rebuild
		python_mod_optimize "$(python_get_sitedir)/${PN}.py"
	fi
}

multilib-native_pkg_postrm_internal() {
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/${PN}.py
}
