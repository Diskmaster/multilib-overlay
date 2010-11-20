# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gobject-introspection/gobject-introspection-0.9.12.ebuild,v 1.1 2010/10/13 16:18:49 eva Exp $

EAPI="3"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"

inherit gnome2 python multilib-native

DESCRIPTION="Introspection infrastructure for gobject library bindings"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~s390 ~sh ~sparc ~x86"
IUSE="doc test"

RDEPEND=">=dev-libs/glib-2.24:2[lib32?]
	virtual/libffi[lib32?]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig[lib32?]
	sys-devel/flex[lib32?]
	doc? ( >=dev-util/gtk-doc-1.12 )
	test? ( x11-libs/cairo[lib32?] )"

DOCS="AUTHORS CONTRIBUTORS ChangeLog NEWS README TODO"

multilib-native_pkg_setup_internal() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable test tests)"

	python_set_active_version 2
}

multilib-native_src_prepare_internal() {
	# FIXME: Parallel compilation failure with USE=doc
	use doc && MAKEOPTS="-j1"

	# Don't pre-compile .py
	ln -sf $(type -P true) py-compile
}

multilib-native_src_install_internal() {
	gnome2_src_install
	python_convert_shebangs 2 "${ED}"usr/bin/g-ir-scanner
	python_convert_shebangs 2 "${ED}"usr/bin/g-ir-annotation-tool
	find "${ED}" -name "*.la" -delete || die "la files removal failed"
}

multilib-native_pkg_postinst_internal() {
	python_mod_optimize /usr/$(get_libdir)/${PN}/giscanner
	python_need_rebuild
}

multilib-native_pkg_postrm_internal() {
	python_mod_cleanup /usr/lib*/${PN}/giscanner
}
