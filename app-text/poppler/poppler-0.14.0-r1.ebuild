# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/poppler/poppler-0.14.0-r1.ebuild,v 1.4 2010/06/21 15:32:14 ssuominen Exp $

EAPI="2"

inherit cmake-utils multilib-native

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="http://poppler.freedesktop.org/"
SRC_URI="http://dev.gentooexperimental.org/~scarabeus/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE="+abiword cairo cjk curl cxx debug exceptions jpeg jpeg2k +lcms png qt4 +utils +xpdf-headers"
# doc, see src_install

# No test data provided
RESTRICT="test"

COMMON_DEPEND="
	>=media-libs/fontconfig-2.6.0[lib32?]
	>=media-libs/freetype-2.3.9[lib32?]
	sys-libs/zlib[lib32?]
	abiword? ( dev-libs/libxml2:2[lib32?] )
	cairo? (
		dev-libs/glib:2[lib32?]
		>=x11-libs/cairo-1.8.4[lib32?]
		>=x11-libs/gtk+-2.14.0:2[lib32?]
	)
	curl? ( net-misc/curl[lib32?] )
	jpeg? ( >=media-libs/jpeg-7:0[lib32?] )
	jpeg2k? ( media-libs/openjpeg[lib32?] )
	lcms? ( =media-libs/lcms-1*[lib32?] )
	png? ( media-libs/libpng[lib32?] )
	qt4? (
		x11-libs/qt-core:4[lib32?]
		x11-libs/qt-gui:4[lib32?]
	)
"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig[lib32?]
"
RDEPEND="${COMMON_DEPEND}
	!dev-libs/poppler
	!dev-libs/poppler-glib
	!dev-libs/poppler-qt3
	!dev-libs/poppler-qt4
	!app-text/poppler-utils
	cjk? ( >=app-text/poppler-data-0.2.1 )
"

DOCS=(AUTHORS NEWS README README-XPDF TODO)

multilib-native_src_configure_internal() {
	mycmakeargs=(
		-DBUILD_GTK_TESTS=OFF
		-DBUILD_QT4_TESTS=OFF
		-DBUILD_CPP_TESTS=OFF
		-DWITH_Qt3=OFF
		-DENABLE_SPLASH=ON
		-DENABLE_ZLIB=ON
		$(cmake-utils_use_enable abiword)
		$(cmake-utils_use_enable curl LIBCURL)
		$(cmake-utils_use_enable cxx CPP)
		$(cmake-utils_use_enable jpeg2k LIBOPENJPEG)
		$(cmake-utils_use_enable lcms)
		$(cmake-utils_use_enable utils)
		$(cmake-utils_use_enable xpdf-headers XPDF_HEADERS)
		$(cmake-utils_use_with cairo)
		$(cmake-utils_use_with cairo GTK)
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with png)
		$(cmake-utils_use_with qt4)
		$(cmake-utils_use exceptions USE_EXCEPTIONS)
	)

	cmake-utils_src_configure
}

multilib-native_src_install_internal() {
	cmake-utils_src_install

# Restore with 0.14.1 per http://bugs.gentoo.org/323409
#	if use cairo && use doc; then
#		insinto /usr/share/doc/${PF}/html
#		doins -r "${S}"/glib/reference/html/* || die
#	fi
}

multilib-native_pkg_preinst_internal() {
	preserve_old_lib /usr/$(get_libdir)/libpoppler-glib.so.4
	preserve_old_lib /usr/$(get_libdir)/libpoppler.so.5
}

multilib-native_pkg_postinst_internal() {
	preserve_old_lib_notify /usr/$(get_libdir)/libpoppler-glib.so.4
	preserve_old_lib_notify /usr/$(get_libdir)/libpoppler.so.5
}
