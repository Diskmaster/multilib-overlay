# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-keyring/gnome-keyring-2.28.1.ebuild,v 1.2 2009/10/30 00:34:45 eva Exp $

EAPI="2"

inherit gnome2 pam virtualx multilib-native

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc pam test"
# USE=valgrind is probably not a good idea for the tree

RDEPEND=">=dev-libs/glib-2.16[lib32?]
	>=x11-libs/gtk+-2.6[lib32?]
	gnome-base/gconf[lib32?]
	>=sys-apps/dbus-1.0[lib32?]
	pam? ( virtual/pam )
	pam? ( sys-libs/pam[lib32?] )
	>=dev-libs/libgcrypt-1.2.2[lib32?]
	>=dev-libs/libtasn1-1[lib32?]"
#	valgrind? ( dev-util/valgrind )"
DEPEND="${RDEPEND}
	sys-devel/gettext[lib32?]
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9[lib32?]
	doc? ( >=dev-util/gtk-doc-1.9 )"

DOCS="AUTHORS ChangeLog NEWS README TODO keyring-intro.txt"

multilib-native_pkg_setup_internal() {
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		--with-root-certs=/usr/share/ca-certificates/
		--enable-acl-prompts
		--enable-ssh-agent"
#		$(use_enable valgrind)
}

multilib-native_src_prepare_internal() {
	gnome2_src_prepare

	# Remove silly CFLAGS
	sed 's:CFLAGS="$CFLAGS -Werror:CFLAGS="$CFLAGS:' \
		-i configure.in configure || die "sed failed"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "emake check failed!"
}
