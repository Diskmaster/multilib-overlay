# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXft/libXft-2.1.14.ebuild,v 1.11 2010/06/14 17:35:17 grobian Exp $

EAPI="2"

inherit x-modular flag-o-matic multilib-native

DESCRIPTION="X.Org Xft library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND="x11-libs/libXrender[lib32?]
	x11-libs/libX11[lib32?]
	x11-libs/libXext[lib32?]
	x11-proto/xproto
	media-libs/freetype[lib32?]
	>=media-libs/fontconfig-2.2[lib32?]"
DEPEND="${RDEPEND}"

multilib-native_pkg_setup_internal() {
	# No such function yet
	# x-modular_pkg_setup

	# (#125465) Broken with Bdirect support
	filter-flags -Wl,-Bdirect
	filter-ldflags -Bdirect
	filter-ldflags -Wl,-Bdirect
}

multilib-native_src_install_internal() {
	multilib-native_check_inherited_funcs src_install
	prep_ml_binaries /usr/bin/xft-config
}
