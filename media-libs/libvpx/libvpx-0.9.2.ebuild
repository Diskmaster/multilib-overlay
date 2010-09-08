# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libvpx/libvpx-0.9.2.ebuild,v 1.1 2010/09/08 00:00:10 lu_zero Exp $

EAPI=2
inherit multilib toolchain-funcs multilib-native

if [[ ${PV} == *9999* ]]; then
	inherit git
	EGIT_REPO_URI="git://review.webmproject.org/${PN}.git"
	KEYWORDS=""
elif [[ ${PV} == *pre* ]]; then
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI="http://webm.googlecode.com/files/${PN}-v${PV}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="WebM VP8 Codec SDK"
HOMEPAGE="http://www.webmproject.org"

LICENSE="BSD"
SLOT="0"
IUSE="altivec debug doc mmx postproc sse sse2 sse3 ssse3 +threads"

RDEPEND=""
DEPEND="amd64? ( dev-lang/yasm )
	x86? ( dev-lang/yasm )
	doc? (
		app-doc/doxygen
		dev-lang/php
	)
"

multilib-native_src_configure_internal() {
	tc-export CC
	./configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--enable-pic \
		--enable-vp8 \
		--enable-shared \
		$(use_enable altivec) \
		$(use_enable mmx) \
		$(use_enable sse) \
		$(use_enable sse2) \
		$(use_enable sse3) \
		$(use_enable ssse3) \
		$(use_enable debug) \
		$(use_enable debug debug-libs) \
		$(use_enable doc install-docs) \
		$(use_enable postproc) \
		$(use_enable threads multithread) \
		|| die
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS CHANGELOG README || die
}
