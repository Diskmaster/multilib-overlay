# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/freeglut/freeglut-2.6.0_rc1.ebuild,v 1.2 2009/08/21 08:41:11 scarabeus Exp $

EAPI="2"

inherit eutils flag-o-matic libtool multilib-native

DESCRIPTION="A completely OpenSourced alternative to the OpenGL Utility Toolkit (GLUT) library"
HOMEPAGE="http://freeglut.sourceforge.net/"
SRC_URI="mirror://sourceforge/freeglut/${P/_/-}.tar.gz"

LICENSE="X11"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug"

RDEPEND="virtual/opengl[lib32?]
	virtual/glu[lib32?]
	!media-libs/glut"

# The imake dependency is because of the AC_PATH_XTRA function in
# /usr/share/autoconf/autoconf/libs.m4 , which uses xmkmf (an imake wrapper) to
# produce a makefile which prints system library locations.  If imake is built
# without lib32 in USE, it will get lib64 library locations, which freeglut will
# put in its .la files, slowing poisoning other .la files as time goes by.

DEPEND="${RDEPEND}
	x11-misc/imake[lib32?]"
# Doesn't remove imake until post-build, bug in portage I think?
#	lib32? ( !x11-misc/imake[-lib32] )"

S="${WORKDIR}/${P/_*/}"

src_prepare() {
	# fixes compilation in multilib environment
	# maybe, this patch causes the problem on 32ul on ppc64, please don't drop use lib32
	# use lib32 && epatch "${FILESDIR}"/${P}-multilib-fix.patch

	# Needed for sane .so versionning on bsd, please don't drop
	elibtoolize
}

multilib-native_src_configure_internal() {
	econf \
		--disable-warnings \
		--disable-warnings-as-errors \
		--enable-replace-glut \
		$(use_enable debug)
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"
	dohtml -r doc/*.html doc/*.png || die "dohtml failed"
}
