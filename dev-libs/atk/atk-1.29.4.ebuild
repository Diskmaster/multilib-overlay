# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/atk/atk-1.28.0.ebuild,v 1.1 2009/10/29 21:26:53 eva Exp $

EAPI=2

inherit gnome2 multilib-native

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="http://live.gnome.org/GAP/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND=">=dev-libs/glib-2"[lib32?]
DEPEND="${RDEPEND}
	>=dev-lang/perl-5[lib32?]
	sys-devel/gettext[lib32?]
	>=dev-util/pkgconfig-0.9[lib32?]
	doc? ( >=dev-util/gtk-doc-1 )
	dev-libs/gobject-introspection[lib32?]"

DOCS="AUTHORS ChangeLog NEWS README"
