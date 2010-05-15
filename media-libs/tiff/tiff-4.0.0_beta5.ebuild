# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tiff/tiff-4.0.0_beta5.ebuild,v 1.1 2010/05/12 03:38:15 nerdboy Exp $

EAPI=2
inherit eutils libtool multilib-native

MY_PV="${PV/_beta/beta}"
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="Beta release of TIFF4 (Tag Image File Format) image library."
HOMEPAGE="http://www.remotesensing.org/libtiff/"
SRC_URI="ftp://ftp.remotesensing.org/pub/libtiff/${PN}-${MY_PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+bigtiff +cxx jpeg jbig -mdi zlib"

DEPEND="jpeg? ( >=media-libs/jpeg-6b:0[lib32?] )
	jbig? ( media-libs/jbigkit[lib32?] )
	zlib? ( sys-libs/zlib[lib32?] )"

multilib-native_src_prepare_internal() {
	epatch "${FILESDIR}"/${PN}-3.9.2-CVE-2009-2347.patch
	elibtoolize
}

multilib-native_src_configure_internal() {
	use prefix || EPREFIX=
	econf \
		--disable-dependency-tracking \
		--disable-silent-rules \
		$(use_enable bigtiff largefile) \
		$(use_enable cxx) \
		$(use_enable zlib) \
		$(use_enable jpeg) \
		$(use_enable jbig) \
		$(use_enable mdi) \
		--without-x \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README TODO
}

multilib-native_pkg_postinst_internal() {
	if use jbig; then
		echo
		elog "JBIG support is intended for Hylafax fax compression, so we"
		elog "really need more feedback in other areas (most testing has"
		elog "been done with fax).  Be sure to recompile anything linked"
		elog "against tiff."
		echo
	fi
}
