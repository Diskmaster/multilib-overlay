# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/adns/adns-1.4-r1.ebuild,v 1.2 2010/06/15 16:46:12 hwoarang Exp $

EAPI="2"

inherit eutils multilib toolchain-funcs multilib-native

DESCRIPTION="Advanced, easy to use, asynchronous-capable DNS client library and utilities"
HOMEPAGE="http://www.chiark.greenend.org.uk/~ian/adns/"
SRC_URI="ftp://ftp.chiark.greenend.org.uk/users/ian/adns/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

multilib-native_src_prepare_internal() {
	epatch "${FILESDIR}"/${P}-cnamechain.patch
	#remove bogus test wrt bug #295072
	rm "${S}"/regress/case-cnametocname.sys
}

multilib-native_src_configure_internal() {
	CC=$(tc-getCC) econf || die "econf failed"
}

multilib-native_src_compile_internal() {
	emake AR=$(tc-getAR) RANLIB=$(tc-getRANLIB) || die "emake failed"
}

multilib-native_src_install_internal() {
	dodir /usr/{include,bin,$(get_libdir)}
	emake prefix="${D}"/usr libdir="${D}"/usr/$(get_libdir) install || die "emake install failed"
	dodoc README TODO changelog "${FILESDIR}"/README.security
	dohtml *.html
}

multilib-native_pkg_postinst_internal() {
	ewarn "$(<${FILESDIR}/README.security)"
}
