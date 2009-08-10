# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gd/gd-2.0.35.ebuild,v 1.11 2008/03/30 23:08:36 ricmm Exp $

EAPI=2

inherit autotools multilib-native

DESCRIPTION="A graphics library for fast image creation"
HOMEPAGE="http://libgd.org/"
SRC_URI="http://libgd.org/releases/${P}.tar.bz2"

LICENSE="|| ( as-is BSD )"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="fontconfig jpeg png truetype xpm"

DEPEND="fontconfig? ( media-libs/fontconfig[lib32?] )
	jpeg? ( >=media-libs/jpeg-6b[lib32?] )
	png? ( >=media-libs/libpng-1.2.5 sys-libs/zlib[lib32?] )
	truetype? ( >=media-libs/freetype-2.1.5[lib32?] )
	xpm? ( x11-libs/libXpm x11-libs/libXt[lib32?] )"

multilib-native_src_prepare_internal() {
	eautoconf
	find . -type f -print0 | xargs -0 touch -r configure
}

multilib-native_src_configure_internal() {
	econf \
		$(use_with fontconfig) \
		$(use_with png) \
		$(use_with truetype freetype) \
		$(use_with jpeg) \
		$(use_with xpm) \
		|| die
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die
	dodoc INSTALL README*
	dohtml -r ./
}
