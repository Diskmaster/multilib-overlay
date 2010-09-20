# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXcomposite/libXcomposite-0.4.2.ebuild,v 1.7 2010/09/19 20:36:27 armin76 Exp $

EAPI=3
inherit xorg-2 multilib-native

DESCRIPTION="X.Org Xcomposite library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ~ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

RDEPEND="x11-libs/libX11[lib32?]
	x11-libs/libXfixes[lib32?]
	x11-libs/libXext[lib32?]
	>=x11-proto/compositeproto-0.4[lib32?]
	x11-proto/xproto[lib32?]"
DEPEND="${RDEPEND}
	doc? ( app-text/xmlto )"

multilib-native_src_configure_internal() {
	CONFIGURE_OPTIONS="$(use_with doc xmlto)"
	xorg-2_src_configure
}
