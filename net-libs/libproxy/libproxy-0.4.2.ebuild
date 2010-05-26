# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libproxy/libproxy-0.4.2.ebuild,v 1.1 2010/05/21 14:35:03 tester Exp $

EAPI="2"
CMAKE_MIN_VERSION="2.8"

inherit cmake-utils eutils python portability multilib-native

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="http://code.google.com/p/libproxy/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug gnome kde networkmanager perl python vala webkit xulrunner"

RDEPEND="
	gnome? ( gnome-base/gconf[lib32?] )
	kde? ( >=kde-base/kdelibs-4.3 )
	networkmanager? ( net-misc/networkmanager[lib32?] )
	perl? (	dev-lang/perl[lib32?] )
	python? ( >=dev-lang/python-2.5[lib32?] )
	vala? ( dev-lang/vala[lib32?] )
	webkit? ( net-libs/webkit-gtk[lib32?] )
	xulrunner? ( >=net-libs/xulrunner-1.9.0.11-r1:1.9[lib32?] )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19[lib32?]"

DOCS="AUTHORS NEWS README ChangeLog"

multilib-native_src_prepare_internal() {
	base_src_prepare
	if use debug; then
	  sed "s/-g -Wall -Werror /-g -Wall /" CMakeLists.txt -i
	else
	  sed "s/-g -Wall -Werror / /" CMakeLists.txt -i
	fi
}

multilib-native_src_configure_internal() {
	mycmakeargs=(
			-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
			-DCMAKE_LD_FLAGS="${CXXFLAGS}"
			$(cmake-utils_use_with gnome GNOME)
			$(cmake-utils_use_with kde KDE4)
			$(cmake-utils_use_with networkmanager NM)
			$(cmake-utils_use_with perl PERL)
			$(cmake-utils_use_with python PYTHON)
			$(cmake-utils_use_with vala VALA)
			$(cmake-utils_use_with webkit WEBKIT)
			$(cmake-utils_use_with xulrunner MOZJS)
	)
	cmake-utils_src_configure
}

multilib-native_pkg_postinst_internal() {
	if use python; then
		python_need_rebuild
		python_mod_optimize "$(python_get_sitedir)/${PN}.py"
	fi
}

multilib-native_pkg_postrm_internal() {
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/${PN}.py
}
