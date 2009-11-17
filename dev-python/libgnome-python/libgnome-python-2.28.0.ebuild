# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/libgnome-python/libgnome-python-2.26.1.ebuild,v 1.4 2009/10/16 23:35:54 maekke Exp $

EAPI=2

GCONF_DEBUG="no"

G_PY_PN="gnome-python"
G_PY_BINDINGS="gnome gnomeui"

inherit gnome-python-common multilib-native

DESCRIPTION="Python bindings for essential GNOME libraries"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS=""
IUSE="examples"

RDEPEND=">=gnome-base/libgnome-2.24.1[lib32?]
	>=gnome-base/libgnomeui-2.24.0[lib32?]
	>=dev-python/pyorbit-2.24.0[lib32?]
	>=dev-python/libbonobo-python-${PV}[lib32?]
	>=dev-python/gnome-vfs-python-${PV}[lib32?]
	>=dev-python/libgnomecanvas-python-${PV}[lib32?]
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}"

EXAMPLES="examples/*
	examples/popt/*"
