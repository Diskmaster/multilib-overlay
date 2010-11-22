# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-base/gst-plugins-base-0.10.30.ebuild,v 1.3 2010/11/22 05:37:26 ford_prefect Exp $

EAPI=2

# order is important, gnome2 after gst-plugins
inherit gst-plugins-base gst-plugins10 gnome2 flag-o-matic autotools eutils multilib-native
# libtool

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="http://gstreamer.sourceforge.net"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="introspection nls +orc"

RDEPEND=">=dev-libs/glib-2.20[lib32?]
	>=media-libs/gstreamer-0.10.30[lib32?]
	dev-libs/libxml2[lib32?]
	app-text/iso-codes
	orc? ( >=dev-lang/orc-0.4.5[lib32?] )
	!<media-libs/gst-plugins-bad-0.10.10"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.11.5[lib32?] )
	dev-util/pkgconfig[lib32?]
	dev-util/gtk-doc-am"

GST_PLUGINS_BUILD=""

DOCS="AUTHORS NEWS README RELEASE"

multilib-native_src_unpack_internal() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.10.29-make-382.patch
	# From upstream commit 5f5c52cb
	epatch "${FILESDIR}"/${P}-fix-tag-test-linking.patch
	eautoreconf
}

multilib-native_src_configure_internal() {
	# gst doesnt handle opts well, last tested with 0.10.15
	strip-flags
	replace-flags "-O3" "-O2"

	gst-plugins-base_src_configure \
		$(use_enable introspection) \
		$(use_enable nls) \
		$(use_enable orc)
}

multilib-native_src_install_internal() {
	gnome2_src_install
}
