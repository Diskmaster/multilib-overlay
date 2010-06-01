# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/wine/wine-1.1.26.ebuild,v 1.8 2009/12/26 17:25:38 vapier Exp $

EAPI="2"

inherit multilib eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://source.winehq.org/git/wine.git"
	inherit git
	SRC_URI=""
	KEYWORDS=""
else
	MY_P="${PN}-${PV/_/-}"
	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
	KEYWORDS="-* ~amd64 ~x86 ~x86-fbsd"
	S=${WORKDIR}/${MY_P}
fi

GV="0.9.1"
DESCRIPTION="free implementation of Windows(tm) on Unix"
HOMEPAGE="http://www.winehq.org/"
SRC_URI="${SRC_URI}
	gecko? ( mirror://sourceforge/wine/wine_gecko-${GV}.cab )"

LICENSE="LGPL-2.1"
SLOT="0"
# Don't add lib32 to IUSE -- otherwise it can be turned off, which would make no
# sense!  package.use.force doesn't work in overlay profiles...
IUSE="alsa cups dbus esd +gecko gnutls hal jack jpeg lcms ldap nas ncurses +opengl oss png samba scanner ssl win64 +X xcomposite xinerama xml"
RESTRICT="test" #72375

# There isn't really a better way of doing these dependencies without messing up
# the metadata cache :(
RDEPEND="amd64? ( !win64? (
		>=media-libs/freetype-2.0.0[lib32]
		dev-lang/perl[lib32]
		alsa? ( media-libs/alsa-lib[lib32] )
		cups? ( net-print/cups[lib32] )
		dbus? ( sys-apps/dbus[lib32] )
		esd? ( media-sound/esound[lib32] )
		gnutls? ( net-libs/gnutls[lib32] )
		hal? ( sys-apps/hal[lib32] )
		jack? ( media-sound/jack-audio-connection-kit[lib32] )
		jpeg? ( media-libs/jpeg[lib32] )
		ldap? ( net-nds/openldap[lib32] )
		lcms? ( media-libs/lcms[lib32] )
		nas? ( media-libs/nas[lib32] )
		ncurses? ( >=sys-libs/ncurses-5.2[lib32] )
		opengl? ( virtual/opengl[lib32] )
		png? ( media-libs/libpng[lib32] )
		samba? ( >=net-fs/samba-3.0.25[lib32] )
		scanner? ( media-gfx/sane-backends[lib32] )
		ssl? ( dev-libs/openssl[lib32] )
		X? (
			x11-libs/libXcursor[lib32]
			x11-libs/libXrandr[lib32]
			x11-libs/libXi[lib32]
			x11-libs/libXmu[lib32]
			x11-libs/libXxf86vm[lib32]
		)
		xcomposite? ( x11-libs/libXcomposite[lib32] )
		xinerama? ( x11-libs/libXinerama[lib32] )
		xml? ( dev-libs/libxml2[lib32] dev-libs/libxslt[lib32] )
	) )
	>=media-libs/freetype-2.0.0
	dev-lang/perl
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	dbus? ( sys-apps/dbus )
	esd? ( media-sound/esound )
	gnutls? ( net-libs/gnutls )
	hal? ( sys-apps/hal )
	jack? ( media-sound/jack-audio-connection-kit )
	jpeg? ( media-libs/jpeg )
	ldap? ( net-nds/openldap )
	lcms? ( media-libs/lcms )
	nas? ( media-libs/nas )
	ncurses? ( >=sys-libs/ncurses-5.2 )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng )
	samba? ( >=net-fs/samba-3.0.25 )
	scanner? ( media-gfx/sane-backends )
	ssl? ( dev-libs/openssl )
	X? (
		x11-libs/libXcursor
		x11-libs/libXrandr
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXxf86vm
	)
	xcomposite? ( x11-libs/libXcomposite )
	xinerama? ( x11-libs/libXinerama )
	xml? ( dev-libs/libxml2 dev-libs/libxslt )
	media-fonts/corefonts
	dev-perl/XML-Simple
	X? ( x11-apps/xmessage )
	win64? ( >=sys-devel/gcc-4.4.0 )"
DEPEND="${RDEPEND}
	X? (
		x11-proto/inputproto
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
	)
	sys-devel/bison
	sys-devel/flex"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git_src_unpack
	else
		unpack ${MY_P}.tar.bz2
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1.15-winegcc.patch #260726
	epatch_user #282735
	sed -i '/^UPDATE_DESKTOP_DATABASE/s:=.*:=true:' tools/Makefile.in || die
	sed -i '/^MimeType/d' tools/wine.desktop || die #117785
}

src_configure() {
	export LDCONFIG=/bin/true

	use amd64 && ! use win64 && multilib_toolchain_setup x86

	# XXX: should check out these flags too:
	#	audioio capi fontconfig freetype gphoto
	econf \
		--sysconfdir=/etc/wine \
		$(use_with alsa) \
		$(use_with cups) \
		$(use_with esd) \
		$(use_with gnutls) \
		$(! use dbus && echo --without-hal || use_with hal) \
		$(use_with jack) \
		$(use_with jpeg) \
		$(use_with lcms cms) \
		$(use_with ldap) \
		$(use_with nas) \
		$(use_with ncurses curses) \
		$(use_with opengl) \
		$(use_with oss) \
		$(use_with png) \
		$(use_with scanner sane) \
		$(use_with ssl openssl) \
		$(use_enable win64) \
		$(use_with X x) \
		$(use_with xcomposite) \
		$(use_with xinerama) \
		$(use_with xml) \
		$(use_with xml xslt) \
		|| die "configure failed"

	emake -j1 depend || die "depend"
}

src_compile() {
	emake all || die "all"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ANNOUNCE AUTHORS README
	if use gecko ; then
		insinto /usr/share/wine/gecko
		doins "${DISTDIR}"/wine_gecko-${GV}.cab || die
	fi
}
