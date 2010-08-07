# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXxf86vm/libXxf86vm-1.1.0.ebuild,v 1.11 2010/08/02 18:28:55 armin76 Exp $

EAPI="2"

inherit x-modular multilib-native

DESCRIPTION="X.Org Xxf86vm library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x86-fbsd ~x64-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND="
	>=x11-libs/libX11-1.3[lib32?]
	>=x11-libs/libXext-1.1[lib32?]
	>=x11-proto/xf86vidmodeproto-2.3
"
DEPEND="${RDEPEND}
	x11-proto/xproto"
