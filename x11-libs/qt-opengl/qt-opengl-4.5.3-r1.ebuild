# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-opengl/qt-opengl-4.5.3-r1.ebuild,v 1.3 2009/10/31 13:51:27 maekke Exp $

EAPI="2"
inherit qt4-build multilib-native

DESCRIPTION="The OpenGL module for the Qt toolkit"
SLOT="4"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="qt3support"

DEPEND="~x11-libs/qt-core-${PV}[debug=,qt3support=,lib32?]
	~x11-libs/qt-gui-${PV}[debug=,qt3support=,lib32?]
	virtual/opengl[lib32?]
	virtual/glu[lib32?]"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
src/opengl
src/plugins/graphicssystems/opengl"

QT4_EXTRACT_DIRECTORIES="
include/QtCore
include/QtGui
include/QtOpenGL
src/corelib
src/gui
src/opengl
src/plugins
src/3rdparty"

QCONFIG_ADD="opengl"
QCONFIG_DEFINE="QT_OPENGL"

PATCHES=(
	"${FILESDIR}/qt-${PV}-glib-event-loop.patch"
)

multilib-native_src_configure_internal() {
	myconf="${myconf} -opengl
		$(qt_use qt3support)"

	qt4-build_src_configure

	# Not building tools/designer/src/plugins/tools/view3d as it's
	# commented out of the build in the source
}
