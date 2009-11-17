# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/libgnomecanvas-python/libgnomecanvas-python-2.26.1.ebuild,v 1.4 2009/10/16 23:04:23 maekke Exp $

EAPI="2"

GCONF_DEBUG="no"

G_PY_PN="gnome-python"
G_PY_BINDINGS="gnomecanvas"

inherit gnome-python-common multilib-native

DESCRIPTION="Python bindings for the Gnome Canvas library"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS=""
IUSE="examples"

RDEPEND=">=gnome-base/libgnomecanvas-2.8.0[lib32?]
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}"

EXAMPLES="examples/canvas/*"
