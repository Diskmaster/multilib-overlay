# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXScrnSaver/libXScrnSaver-1.2.0.ebuild,v 1.10 2010/06/04 13:59:52 gmsoft Exp $

EAPI=3
inherit xorg-2 multilib-native

DESCRIPTION="X.Org XScrnSaver library"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libX11[lib32?]
	x11-libs/libXext[lib32?]
	>=x11-proto/scrnsaverproto-1.2[lib32?]"
DEPEND="${RDEPEND}"
