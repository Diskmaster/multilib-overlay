# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pkgconfig/pkgconfig-0.25.ebuild,v 1.1 2010/06/17 09:29:59 ssuominen Exp $

EAPI=2
inherit flag-o-matic multilib-native

MY_P=pkg-config-${PV}

DESCRIPTION="Package config system that manages compile/link flags"
HOMEPAGE="http://pkgconfig.freedesktop.org/wiki/"
SRC_URI="http://pkgconfig.freedesktop.org/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="elibc_FreeBSD hardened"

S=${WORKDIR}/${MY_P}

multilib-native_src_configure_internal() {
	use ppc64 && use hardened && replace-flags -O[2-3] -O1

	# Force using all the requirements when linking, so that needed -pthread
	# lines are inherited between libraries
	local myconf
	use elibc_FreeBSD && myconf="--enable-indirect-deps"

	econf \
		--docdir=/usr/share/doc/${PF}/html \
		${myconf}
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README

	prep_ml_binaries /usr/bin/pkg-config
}
