# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/schroedinger/schroedinger-1.0.9.ebuild,v 1.2 2010/04/21 16:09:03 ssuominen Exp $

EAPI=3
inherit autotools eutils multilib-native

DESCRIPTION="C-based libraries for the Dirac video codec"
HOMEPAGE="http://www.diracvideo.org/"
SRC_URI="http://www.diracvideo.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2 MIT MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-lang/orc-0.4.3[lib32?]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig[lib32?]
	dev-util/gtk-doc-am"

multilib-native_src_prepare_internal() {
	epatch "${FILESDIR}"/${P}-asneeded.patch

	sed -i \
		-e '/AS_COMPILER_FLAG(-O3/d' \
		configure.ac || die

	AT_M4DIR="m4" eautoreconf
}

multilib-native_src_configure_internal() {
	econf \
		--disable-dependency-tracking \
		--with-html-dir="${EPREFIX}/usr/share/doc/${PF}/html"
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README TODO
}
