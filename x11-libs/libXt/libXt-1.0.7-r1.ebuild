# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXt/libXt-1.0.7-r1.ebuild,v 1.10 2010/01/19 20:09:44 armin76 Exp $

EAPI="2"

SNAPSHOT="yes"

inherit x-modular flag-o-matic toolchain-funcs multilib-native

DESCRIPTION="X.Org Xt library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11[lib32?]
	x11-libs/libSM[lib32?]
	x11-proto/xproto[lib32?]
	x11-proto/kbproto[lib32?]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-fix-cross-compile-again.patch" )

multilib-native_pkg_setup_internal() {
	# No such function yet
	# x-modular_pkg_setup

	# (#125465) Broken with Bdirect support
	filter-flags -Wl,-Bdirect
	filter-ldflags -Bdirect
	filter-ldflags -Wl,-Bdirect

	if tc-is-cross-compiler; then
		export CFLAGS_FOR_BUILD="${BUILD_CFLAGS}"
	fi
}
