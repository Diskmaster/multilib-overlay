# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/atk/atk-1.30.0.ebuild,v 1.1 2010/06/13 15:40:50 pacho Exp $

EAPI="2"

inherit gnome2 multilib-native

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="http://live.gnome.org/GAP/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

# FIXME: This package also supports introspection
RDEPEND=">=dev-libs/glib-2[lib32?]"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5[lib32?]
	sys-devel/gettext[lib32?]
	>=dev-util/pkgconfig-0.9[lib32?]
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

multilib-native_pkg_setup_internal() {
	G2CONF="${G2CONF} --disable-introspection"
}
