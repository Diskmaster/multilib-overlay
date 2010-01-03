# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-demo/qt-demo-4.6.0.ebuild,v 1.2 2009/12/25 15:39:38 abcd Exp $

EAPI="2"
inherit qt4-build multilib-native

DESCRIPTION="Demonstration module of the Qt toolkit"
SLOT="4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="~x11-libs/qt-assistant-${PV}:${SLOT}[aqua=,lib32?]
	~x11-libs/qt-core-${PV}:${SLOT}[aqua=,lib32?]
	~x11-libs/qt-dbus-${PV}:${SLOT}[aqua=,lib32?]
	~x11-libs/qt-gui-${PV}:${SLOT}[aqua=,lib32?]
	~x11-libs/qt-multimedia-${PV}:${SLOT}[aqua=,lib32?]
	~x11-libs/qt-opengl-${PV}:${SLOT}[aqua=,lib32?]
	|| ( ~x11-libs/qt-phonon-${PV}:${SLOT}[aqua=,lib32?] media-sound/phonon[aqua=,lib32?] )
	~x11-libs/qt-script-${PV}:${SLOT}[aqua=,lib32?]
	~x11-libs/qt-sql-${PV}:${SLOT}[aqua=,lib32?]
	~x11-libs/qt-svg-${PV}:${SLOT}[aqua=,lib32?]
	~x11-libs/qt-test-${PV}:${SLOT}[aqua=,lib32?]
	~x11-libs/qt-webkit-${PV}:${SLOT}[aqua=,lib32?]
	~x11-libs/qt-xmlpatterns-${PV}:${SLOT}[aqua=,lib32?]"

RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="demos
	examples"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
	doc/src/images
	src/
	include/
	tools/"

PATCHES=(
	"${FILESDIR}/${PN}-4.6-plugandpaint.patch"
)

multilib-native_src_install_internal() {
	insinto "${QTDOCDIR#${EPREFIX}}"/src
	doins -r "${S}"/doc/src/images || die "Installing images failed."

	qt4-build_src_install
}
