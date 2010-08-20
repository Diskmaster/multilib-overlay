# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libbonoboui/libbonoboui-2.24.3.ebuild,v 1.6 2010/08/18 21:34:34 maekke Exp $

EAPI="2"

GCONF_DEBUG="no"

inherit eutils virtualx gnome2 multilib-native

DESCRIPTION="User Interface part of libbonobo"
HOMEPAGE="http://developer.gnome.org/arch/gnome/componentmodel/bonobo.html"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ~ppc ~ppc64 sh sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="doc"

# GTK+ dep due to bug #126565
RDEPEND=">=gnome-base/libgnomecanvas-1.116[lib32?]
	>=gnome-base/libbonobo-2.22[lib32?]
	>=gnome-base/libgnome-2.13.7[lib32?]
	>=dev-libs/libxml2-2.4.20[lib32?]
	>=gnome-base/gconf-2[lib32?]
	>=x11-libs/gtk+-2.8.12[lib32?]
	>=dev-libs/glib-2.6.0[lib32?]
	>=gnome-base/libglade-1.99.11[lib32?]
	>=dev-libs/popt-1.5[lib32?]"

DEPEND="${RDEPEND}
	x11-apps/xrdb
	sys-devel/gettext[lib32?]
	>=dev-util/pkgconfig-0.20[lib32?]
	>=dev-util/intltool-0.40
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

multilib-native_src_compile_internal() {
	addpredict "/root/.gnome2_private"

	gnome2_src_compile
}

src_test() {
	addwrite "/root/.gnome2_private"
	Xemake check || die "tests failed"
}
