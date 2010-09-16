# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXext/libXext-1.1.2-r1.ebuild,v 1.1 2010/09/05 07:49:48 grobian Exp $

EAPI=3
inherit xorg-2 multilib-native

DESCRIPTION="X.Org Xext library"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND=">=x11-libs/libX11-1.1.99.1[lib32?]"
DEPEND="${RDEPEND}
	>=x11-proto/xextproto-7.0.99.2[lib32?]
	>=x11-proto/xproto-7.0.13[lib32?]"

multilib-native_src_prepare_internal() {
	xorg-2_src_prepare
	epatch "${FILESDIR}/${P}-xhidden.patch"
}
