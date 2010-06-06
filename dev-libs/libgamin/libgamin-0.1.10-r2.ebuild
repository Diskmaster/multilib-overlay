# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgamin/libgamin-0.1.10-r2.ebuild,v 1.11 2009/09/25 10:51:18 flameeyes Exp $

EAPI="2"

inherit autotools eutils flag-o-matic libtool python multilib-native

MY_PN=${PN//lib/}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Library providing the FAM File Alteration Monitor API"
HOMEPAGE="http://www.gnome.org/~veillard/gamin/"
SRC_URI="http://www.gnome.org/~veillard/${MY_PN}/sources/${MY_P}.tar.gz
	mirror://gentoo/${MY_PN}-0.1.9-freebsd.patch.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="debug kernel_linux python"

RESTRICT="test" # need gam-server

RDEPEND="python? ( virtual/python )
	!app-admin/fam
	!<app-admin/gamin-0.1.10"

DEPEND="${RDEPEND}
	dev-util/pkgconfig[lib32?]"

S="${WORKDIR}/${MY_P}"

multilib-native_src_prepare_internal() {
	# Fix QA warnings, bug #257281, upstream #466791
	epatch "${FILESDIR}/${P}-compilewarnings.patch"

	# Fix compile warnings; bug #188923
	epatch "${DISTDIR}/${MY_PN}-0.1.9-freebsd.patch.bz2"

	# Fix collision problem due to intermediate library, upstream bug #530635
	epatch "${FILESDIR}/${P}-noinst-lib.patch"

	# autoconf is required as the user-cflags patch modifies configure.in
	# however, elibtoolize is also required, so when the above patch is
	# removed, replace the following call with a call to elibtoolize
	eautoreconf

	# disable pyc compiling
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile
}

multilib-native_src_configure_internal() {
	econf --disable-debug \
		--disable-server \
		$(use_enable kernel_linux inotify) \
		$(use_enable debug debug-api) \
		$(use_with python)
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die "installation failed"

	dodoc AUTHORS ChangeLog README TODO NEWS doc/*txt || die "dodoc failed"
	dohtml doc/* || die "dohtml failed"
}

multilib-native_pkg_postinst_internal() {
	if use python; then
		python_version
		python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages
	fi
}

multilib-native_pkg_postrm_internal() {
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages
}
