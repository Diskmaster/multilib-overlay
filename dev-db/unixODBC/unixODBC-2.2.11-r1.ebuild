# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/unixODBC/unixODBC-2.2.11-r1.ebuild,v 1.19 2008/03/13 21:42:01 ricmm Exp $

EAPI="2"

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils multilib autotools multilib-native

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

DESCRIPTION="ODBC Interface for Linux."
HOMEPAGE="http://www.unixodbc.org/"
SRC_URI="http://www.unixodbc.org/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="qt3"

DEPEND=">=sys-libs/readline-4.1[lib32?]
		>=sys-libs/ncurses-5.2[lib32?]
		qt3? ( =x11-libs/qt-3*[lib32?] )"
RDEPEND="${DEPEND}"

# the configure.in patch is required for 'use qt3'
multilib-native_src_prepare_internal() {
	# solve bug #110167
	epatch "${FILESDIR}/${P}-flex.patch"
	# braindead check in configure fails - hackish approach
	epatch "${FILESDIR}/${P}-configure.in.patch"
	epatch "${FILESDIR}/${P}-Makefile.am.patch"

	eautoreconf
}

multilib-native_src_configure_internal() {
	local myconf

	if use qt3 && ! use mips ; then
		myconf="--enable-gui=yes --x-libraries=/usr/$(get_libdir)
			--with-qt-libraries=/usr/qt/3/$(get_libdir)"
		[[ -d "/usr/qt/3/include/gentoo-multilib" ]] && \
			myconf="${myconf} --with-qt-includes=/usr/qt/3/include/gentoo-multilib/${ABI}"
	else
		myconf="--enable-gui=no"
	fi

	econf --prefix=/usr \
		--sysconfdir=/etc/${PN} \
		--libdir=/usr/$(get_libdir) \
		${myconf} || die "econf failed"
}

multilib-native_src_compile_internal() {
	emake -j1 || die "emake failed"
}

multilib-native_src_install_internal() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README*
	find doc/ -name "Makefile*" -exec rm '{}' \;
	dohtml doc/*
	prepalldocs
}
