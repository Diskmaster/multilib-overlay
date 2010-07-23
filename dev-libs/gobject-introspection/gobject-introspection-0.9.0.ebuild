# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gobject-introspection/gobject-introspection-0.9.0.ebuild,v 1.2 2010/07/21 19:11:53 maekke Exp $

EAPI="3"

PYTHON_DEPEND="2:2.5"

inherit python gnome2 multilib-native

DESCRIPTION="Introspection infrastructure for gobject library bindings"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc test"

RDEPEND=">=dev-libs/glib-2.19.0[lib32?]
	virtual/libffi[lib32?]"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.12 )
	dev-util/pkgconfig[lib32?]
	sys-devel/flex[lib32?]
	test? ( x11-libs/cairo[lib32?] )"

multilib-native_src_prepare_internal() {
	G2CONF="${G2CONF} --disable-static"

	# FIXME: Parallel compilation failure with USE=doc
	use doc && MAKEOPTS="-j1"

	# Don't pre-compile .py
	ln -sf $(type -P true) py-compile
}

multilib-native_src_configure_internal() {
	econf $(use_enable test tests) || die "econf failed"
}

multilib-native_pkg_postinst_internal() {
	python_mod_optimize /usr/$(get_libdir)/${PN}/giscanner
	python_need_rebuild
}

multilib-native_pkg_postrm_internal() {
	python_mod_cleanup /usr/lib*/${PN}/giscanner
}
