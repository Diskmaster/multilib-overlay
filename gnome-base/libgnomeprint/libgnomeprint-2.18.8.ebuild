# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeprint/libgnomeprint-2.18.8.ebuild,v 1.1 2010/09/28 20:55:54 eva Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2 multilib-native

DESCRIPTION="Printer handling for Gnome"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2.2"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE="cups doc"

RDEPEND=">=dev-libs/glib-2[lib32?]
	>=media-libs/libart_lgpl-2.3.7[lib32?]
	>=x11-libs/pango-1.5[lib32?]
	>=dev-libs/libxml2-2.4.23[lib32?]
	>=media-libs/fontconfig-1[lib32?]
	>=media-libs/freetype-2.0.5[lib32?]
	sys-libs/zlib[lib32?]
	cups? (
		>=net-print/cups-1.1.20[lib32?]
		>=net-print/libgnomecups-0.2[lib32?] )"
DEPEND="${RDEPEND}
	sys-devel/gettext[lib32?]
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9[lib32?]
	sys-devel/flex[lib32?]
	sys-devel/bison
	doc? (
		~app-text/docbook-xml-dtd-4.1.2
		>=dev-util/gtk-doc-0.9 )"

DOCS="AUTHORS BUGS ChangeLog* NEWS README"

multilib-native_pkg_setup_internal() {
	# Disable papi support until papi is in portage; avoids automagic
	# dependencies on an untracked library.
	G2CONF="${G2CONF} $(use_with cups) --without-papi --disable-static"
}
