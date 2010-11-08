# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-proto/xcb-proto/xcb-proto-1.6.ebuild,v 1.14 2010/11/06 14:42:30 scarabeus Exp $

EAPI=3
PYTHON_DEPEND="2:2.5"

inherit python xorg-2 multilib-native

DESCRIPTION="X C-language Bindings protocol headers"
HOMEPAGE="http://xcb.freedesktop.org/"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/xcb/proto"
[[ ${PV} != 9999* ]] && \
	SRC_URI="http://xcb.freedesktop.org/dist/${P}.tar.bz2"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-libs/libxml2[lib32?]"

multilib-native_pkg_setup_internal() {
	python_set_active_version 2
}

multilib-native_src_install_internal() {
	xorg-2_src_install
	python_clean_installation_image
}

multilib-native_pkg_postinst_internal() {
	python_mod_optimize xcbgen
}

multilib-native_pkg_postrm_internal() {
	python_mod_cleanup xcbgen
}
