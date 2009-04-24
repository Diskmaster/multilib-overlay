# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-keyring/gnome-keyring-2.22.3.ebuild,v 1.1 2008/07/02 21:32:43 eva Exp $

EAPI="2"

inherit gnome2 pam multilib-native

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc hal pam valgrind test"

RDEPEND=">=dev-libs/glib-2.16[lib32?]
	 >=x11-libs/gtk+-2.6[lib32?]
	 gnome-base/gconf[lib32?]
	 >=sys-apps/dbus-1.0[lib32?]
	 hal? ( >=sys-apps/hal-0.5.7[lib32?] )
	 pam? ( virtual/pam )
	 >=dev-libs/libgcrypt-1.2.2[lib32?]
	 >=dev-libs/libtasn1-0.3.4[lib32?]
	 lib32? ( pam? ( sys-libs/pam[lib32] ) )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	doc? ( dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

multilib-xlibs_src_configure_internal() {
	econf \
		${G2CONF} \
		$(use_enable debug) \
		$(use_enable hal) \
		$(use_enable test tests) \
		$(use_enable pam) \
		$(use_with pam pam-dir $(getpam_mod_dir)) \
		$(use_enable valgrind) \
		--with-root-certs=/usr/share/ca-certificates/ \
		--enable-acl-prompts \
		--enable-ssh-agent \
		|| die
}

src_test() {
	emake check || die "emake check failed!"

	emake -C tests run || die "running tests failed!"
}
