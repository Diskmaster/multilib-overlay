# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gnome-doc-utils/gnome-doc-utils-0.16.1.ebuild,v 1.14 2010/06/02 20:45:17 eva Exp $

EAPI="2"

inherit eutils python gnome2 multilib-native

DESCRIPTION="A collection of documentation utilities for the Gnome project"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="hppa ppc64"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.6.12[python,lib32?]
	 >=dev-libs/libxslt-1.1.8[lib32?]
	 >=dev-lang/python-2[lib32?]"
DEPEND="${RDEPEND}
	sys-devel/gettext[lib32?]
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9[lib32?]
	~app-text/docbook-xml-dtd-4.4"
# dev-libs/glib needed for eautofoo, bug #255114.

DOCS="AUTHORS ChangeLog NEWS README"

multilib-native_pkg_setup_internal() {
	G2CONF="${G2CONF} --disable-scrollkeeper"
}

multilib-native_src_prepare_internal() {
	gnome2_src_prepare

	# Make xml2po FHS compliant, bug #190798
	epatch "${FILESDIR}/${PN}-0.16.1-fhs.patch"

	# If there is a need to reintroduce eautomake or eautoreconf, make sure
	# to AT_M4DIR="tools m4", bug #224609 (m4 removes glib build time dep)
}

multilib-native_pkg_postinst_internal() {
	python_need_rebuild
	python_mod_optimize $(python_get_sitedir)/xml2po
	gnome2_pkg_postinst
}

multilib-native_pkg_postrm_internal() {
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/xml2po
	gnome2_pkg_postrm
}
