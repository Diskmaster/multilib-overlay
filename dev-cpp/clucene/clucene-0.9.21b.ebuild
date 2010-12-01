# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/clucene/clucene-0.9.21b.ebuild,v 1.15 2010/04/30 15:45:45 grobian Exp $

inherit eutils multilib-native

MY_P=${PN}-core-${PV}

DESCRIPTION="High-performance, full-featured text search engine based off of lucene in C++"
HOMEPAGE="http://clucene.sourceforge.net/"
SRC_URI="mirror://sourceforge/clucene/${MY_P}.tar.bz2"

LICENSE="|| ( Apache-2.0 LGPL-2.1 )"
SLOT="1"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug doc threads"

DEPEND="doc? ( >=app-doc/doxygen-1.4.2 )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

multilib-native_src_prepare_internal() {
	epatch "${FILESDIR}"/${P}-gcc44.patch #254254
}

multilib-native_src_configure_internal() {
	econf $(use_enable debug) \
		$(use_enable debug cnddebug) \
		$(use_enable threads multithreading) || die "econf failed"
}

multilib-native_src_compile_internal() {
	emake || die "emake failed"
	if use doc ; then
		emake doxygen || die "making docs failed"
	fi
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die "installation failed"
	use doc && dohtml "${S}"/doc/html/*
}
