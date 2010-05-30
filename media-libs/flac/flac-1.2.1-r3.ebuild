# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/flac/flac-1.2.1-r3.ebuild,v 1.11 2009/07/24 11:01:07 ssuominen Exp $

EAPI=2

inherit autotools eutils base multilib-native

DESCRIPTION="free lossless audio encoder and decoder"
HOMEPAGE="http://flac.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-embedded-m4.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="3dnow altivec +cxx debug doc ogg sse"

RDEPEND="ogg? ( >=media-libs/libogg-1.1.3[lib32?] )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )
	!elibc_uclibc? ( sys-devel/gettext[lib32?] )
	dev-util/pkgconfig[lib32?]"

PATCHES=( "${FILESDIR}/${P}-asneeded.patch"
	"${FILESDIR}/${P}-cflags.patch"
	"${FILESDIR}/${P}-asm.patch"
	"${FILESDIR}/${P}-dontbuild-tests.patch"
	"${FILESDIR}/${P}-dontbuild-examples.patch"
	"${FILESDIR}/${P}-gcc-4.3-includes.patch" )

multilib-native_src_prepare_internal() {
	base_src_prepare
	cp "${WORKDIR}"/*.m4 m4 || die "cp failed"
	AT_M4DIR="m4" eautoreconf
}

multilib-native_src_configure_internal() {
	econf $(use_enable ogg) \
		$(use_enable sse) \
		$(use_enable 3dnow) \
		$(use_enable altivec) \
		$(use_enable debug) \
		$(use_enable cxx cpplibs) \
		--disable-examples \
		--disable-doxygen-docs \
		--disable-dependency-tracking \
		--disable-xmms-plugin
}

src_test() {
	if [ $UID != 0 ] ; then
		emake check || die "tests failed"
	else
		ewarn "Tests will fail if ran as root, skipping."
	fi
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die "emake install failed."

	rm -rf "${D}"/usr/share/doc/${P}
	dodoc AUTHORS README
	use doc && dohtml -r doc/html/*
}
