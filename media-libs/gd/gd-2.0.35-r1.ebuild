# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gd/gd-2.0.35-r1.ebuild,v 1.12 2010/05/21 14:19:30 ssuominen Exp $

EAPI=2
inherit autotools multilib-native

DESCRIPTION="A graphics library for fast image creation"
HOMEPAGE="http://libgd.org/"
SRC_URI="http://libgd.org/releases/${P}.tar.bz2"

LICENSE="|| ( as-is BSD )"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="fontconfig jpeg png truetype xpm"

RDEPEND="fontconfig? ( media-libs/fontconfig[lib32?] )
	jpeg? ( >=media-libs/jpeg-6b:0[lib32?] )
	png? ( >=media-libs/libpng-1.2.43-r2:0[lib32?]
		sys-libs/zlib[lib32?] )
	truetype? ( >=media-libs/freetype-2.1.5[lib32?] )
	xpm? ( x11-libs/libXpm[lib32?] x11-libs/libXt[lib32?] )"
DEPEND="${RDEPEND}"

multilib-native_src_prepare_internal() {
	epatch "${FILESDIR}"/${P}-libpng14.patch \
		"${FILESDIR}"/${P}-maxcolors.patch

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

	prep_ml_binaries /usr/bin/gdlib-config
}
