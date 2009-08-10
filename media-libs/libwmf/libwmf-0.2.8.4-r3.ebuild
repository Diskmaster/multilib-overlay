# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libwmf/libwmf-0.2.8.4-r3.ebuild,v 1.7 2009/05/18 18:53:30 ranger Exp $

EAPI=2

inherit eutils autotools multilib-native

#The configure script finds the 5.50 ghostscript Fontmap file while run.
#This will probably work, especially since the real one (6.50) in this case
#is empty. However beware in case there is any trouble

DESCRIPTION="library for converting WMF files"
HOMEPAGE="http://wvware.sourceforge.net/"
SRC_URI="mirror://sourceforge/wvware/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="X expat xml debug doc gtk"

RDEPEND="virtual/ghostscript
	xml? ( !expat? ( dev-libs/libxml2[lib32?] ) )
	expat? ( dev-libs/expat[lib32?] )
	>=media-libs/freetype-2.0.1[lib32?]
	sys-libs/zlib[lib32?]
	media-libs/libpng[lib32?]
	media-libs/jpeg[lib32?]
	X? (
		x11-libs/libICE[lib32?]
		x11-libs/libSM[lib32?]
		x11-libs/libX11[lib32?]
	)
	gtk? ( >=x11-libs/gtk+-2.1.2[lib32?] ) "
DEPEND="${RDEPEND}
	dev-util/pkgconfig[lib32?]
	X? (
		x11-libs/libXt[lib32?]
		x11-libs/libXpm[lib32?]
	)"
# plotutils are not really supported yet, so looks like that's it

multilib-native_src_prepare_internal() {
	if ! use doc ; then
		sed -e 's:doc::' -i Makefile.am
	fi
	if ! use gtk ; then
		sed -e 's:@LIBWMF_GDK_PIXBUF_TRUE@:#:' -i src/Makefile.in
	fi
	epatch "${FILESDIR}"/${P}-intoverflow.patch
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-pngfix.patch

	eautoreconf
}

multilib-native_src_configure_internal() {
	if use expat && use xml ; then
		elog "You can specify only one USE flag from expat and xml, to use expat"
		elog "or libxml2, respectively."
		elog
		elog "You have both flags enabled, we will default to expat (like autocheck does)."
		myconf="${myconf} --with-expat --without-libxml2"
	else
		myconf="${myconf} $(use_with expat) $(use_with xml libxml2)"
	fi

	# NOTE: The gd that is included is gd-2.0.0. Even with --with-sys-gd, that gd is built
	# and included in libwmf. Since nothing in-tree seems to use media-libs/libwmf[gd],
	# we're explicitly disabling gd use w.r.t. bug 268161
	econf \
		$(use_enable debug) \
		$(use_with X x) \
		--disable-gd \
		--with-sys-gd \
		${myconf} \
		--with-gsfontdir=/usr/share/ghostscript/fonts \
		--with-fontdir=/usr/share/libwmf/fonts/ \
		--with-docdir=/usr/share/doc/${PF} \
		|| die "./configure failed"
}

multilib-native_src_install_internal() {
	make install DESTDIR="${D}" || die
	dodoc README AUTHORS CREDITS ChangeLog NEWS TODO
	prep_ml_binaries /usr/bin/libwmf-config
}

set_gtk_confdir() {
	# An arch specific config directory is used on multilib systems
	has_multilib_profile && GTK2_CONFDIR="${ROOT}etc/gtk-2.0/${CHOST}"
	GTK2_CONFDIR="${GTK2_CONFDIR:-/etc/gtk-2.0}"
}

pkg_postinst() {
	if use gtk; then
		set_gtk_confdir
		gdk-pixbuf-query-loaders > "${GTK2_CONFDIR}/gdk-pixbuf.loaders"
	fi
}

pkg_postrm() {
	if use gtk; then
		set_gtk_confdir
		gdk-pixbuf-query-loaders > "${GTK2_CONFDIR}/gdk-pixbuf.loaders"
	fi
}
