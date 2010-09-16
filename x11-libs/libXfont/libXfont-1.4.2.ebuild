# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXfont/libXfont-1.4.2.ebuild,v 1.6 2010/09/12 19:08:38 klausman Exp $

EAPI=3
inherit xorg-2 flag-o-matic multilib-native

DESCRIPTION="X.Org Xfont library"

KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="ipv6"

RDEPEND="x11-libs/xtrans[lib32?]
	x11-libs/libfontenc[lib32?]
	x11-proto/xproto[lib32?]
	x11-proto/fontsproto[lib32?]
	>=media-libs/freetype-2[lib32?]
	app-arch/bzip2[lib32?]"
DEPEND="${RDEPEND}"

multilib-native_pkg_setup_internal() {
	xorg-2_pkg_setup
	CONFIGURE_OPTIONS="$(use_enable ipv6)
		--with-bzip2
		--disable-devel-docs"

	# (#125465) Broken with Bdirect support
	filter-flags -Wl,-Bdirect
	filter-ldflags -Bdirect
	filter-ldflags -Wl,-Bdirect
}
