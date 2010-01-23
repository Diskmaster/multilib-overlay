# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsndfile/libsndfile-1.0.20.ebuild,v 1.7 2009/05/20 18:09:02 armin76 Exp $

EAPI="2"

inherit eutils libtool autotools multilib-native

MY_P=${P/_pre/pre}

DESCRIPTION="A C library for reading and writing files containing sampled sound"
HOMEPAGE="http://www.mega-nerd.com/libsndfile"
if [[ "${MY_P}" == "${P}" ]]; then
	SRC_URI="http://www.mega-nerd.com/libsndfile/${P}.tar.gz"
else
	SRC_URI="http://www.mega-nerd.com/tmp/${MY_P}b.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="alsa jack minimal sqlite"

RDEPEND="!minimal? ( >=media-libs/flac-1.2.1[lib32?]
		>=media-libs/libogg-1.1.3[lib32?]
		>=media-libs/libvorbis-1.2.1_rc1[lib32?] )
	alsa? ( media-libs/alsa-lib[lib32?] )
	sqlite? ( >=dev-db/sqlite-3.2[lib32?] )
	jack? ( media-sound/jack-audio-connection-kit[lib32?] )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig[lib32?]"

S=${WORKDIR}/${MY_P}

multilib-native_src_prepare_internal() {
	sed -i -e "s/noinst_PROGRAMS/check_PROGRAMS/" "${S}/tests/Makefile.am" \
		"${S}/examples/Makefile.am" || die "sed failed"

	epatch "${FILESDIR}"/${PN}-1.0.17-regtests-need-sqlite.patch \
		"${FILESDIR}"/${PN}-1.0.18-less_strict_tests.patch \
		"${FILESDIR}"/${PN}-1.0.19-automagic_jack.patch

	# cheap fix for multilib
	use lib32 && epatch "${FILESDIR}/${PN}-1.0.19-no-jack-revdep.patch"
	
	rm M4/libtool.m4 M4/lt*.m4 || die "rm failed"

	AT_M4DIR=M4 eautoreconf
	epunt_cxx
}

multilib-native_src_configure_internal() {
	econf $(use_enable sqlite) \
		$(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable !minimal external-libs) \
		--disable-octave \
		--disable-gcc-werror \
		--disable-gcc-pipe \
		--disable-dependency-tracking
	emake || die "emake failed"
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" htmldocdir="/usr/share/doc/${PF}/html" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
