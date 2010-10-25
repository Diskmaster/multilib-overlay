# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtk+/gtk+-2.22.0.ebuild,v 1.2 2010/10/20 21:11:52 eva Exp $

EAPI="3"
PYTHON_DEPEND="2:2.4"

inherit eutils flag-o-matic gnome.org libtool python virtualx multilib-native

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="aqua cups debug doc +introspection jpeg jpeg2k tiff test vim-syntax xinerama"

# NOTE: cairo[svg] dep is due to bug 291283 (not patched to avoid eautoreconf)
RDEPEND="!aqua? (
		x11-libs/libXrender[lib32?]
		x11-libs/libX11[lib32?]
		x11-libs/libXi[lib32?]
		x11-libs/libXt[lib32?]
		x11-libs/libXext[lib32?]
		>=x11-libs/libXrandr-1.3[lib32?]
		x11-libs/libXcursor[lib32?]
		x11-libs/libXfixes[lib32?]
		x11-libs/libXcomposite[lib32?]
		x11-libs/libXdamage[lib32?]
		>=x11-libs/cairo-1.6[X,svg,lib32?]
		x11-libs/gdk-pixbuf[X,introspection?,jpeg?,jpeg2k?,tiff?]
	)
	aqua? (
		>=x11-libs/cairo-1.6[aqua,svg,lib32?]
		x11-libs/gdk-pixbuf[introspection?,jpeg?,jpeg2k?,tiff?]
	)
	xinerama? ( x11-libs/libXinerama[lib32?] )
	>=dev-libs/glib-2.25.10[lib32?]
	>=x11-libs/pango-1.20[introspection?,lib32?]
	>=dev-libs/atk-1.29.2[introspection?,lib32?]
	media-libs/fontconfig[lib32?]
	x11-misc/shared-mime-info
	cups? ( net-print/cups[lib32?] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3[lib32?] )
	!<gnome-base/gail-1000"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9[lib32?]
	!aqua? (
		x11-proto/xextproto
		x11-proto/xproto
		x11-proto/inputproto
		x11-proto/damageproto
	)
	x86-interix? (
		sys-libs/itx-bind
	)
	xinerama? ( x11-proto/xineramaproto )
	>=dev-util/gtk-doc-am-1.11
	doc? (
		>=dev-util/gtk-doc-1.11
		~app-text/docbook-xml-dtd-4.1.2 )
	test? (
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )"
PDEPEND="vim-syntax? ( app-vim/gtk-syntax )"

set_gtk2_confdir() {
	# An arch specific config directory is used on multilib systems
	has_multilib_profile && GTK2_CONFDIR="/etc/gtk-2.0/${CHOST}"
	GTK2_CONFDIR=${GTK2_CONFDIR:=/etc/gtk-2.0}
}

multilib-native_src_prepare_internal() {
	# use an arch-specific config directory so that 32bit and 64bit versions
	# dont clash on multilib systems
	has_multilib_profile && epatch "${FILESDIR}/${PN}-2.21.3-multilib.patch"

	# Don't break inclusion of gtkclist.h, upstream bug 536767
	epatch "${FILESDIR}/${PN}-2.14.3-limit-gtksignal-includes.patch"

	# -O3 and company cause random crashes in applications. Bug #133469
	replace-flags -O3 -O2
	strip-flags

	use ppc64 && append-flags -mminimal-toc

	# Non-working test in gentoo's env
	sed 's:\(g_test_add_func ("/ui-tests/keys-events.*\):/*\1*/:g' \
		-i gtk/tests/testing.c || die "sed 1 failed"
	sed '\%/recent-manager/add%,/recent_manager_purge/ d' \
		-i gtk/tests/recentmanager.c || die "sed 2 failed"

	if use x86-interix; then
		# activate the itx-bind package...
		append-flags "-I${EPREFIX}/usr/include/bind"
		append-ldflags "-L${EPREFIX}/usr/lib/bind"
	fi

	elibtoolize
}

multilib-native_src_configure_internal() {
	local myconf="$(use_enable doc gtk-doc)
		$(use_enable xinerama)
		$(use_enable cups cups auto)
		$(use_enable introspection)
		--disable-papi"
	if use aqua; then
		myconf="${myconf} --with-gdktarget=quartz"
	else
		myconf="${myconf} --with-gdktarget=x11 --with-xinput"
	fi

	# Passing --disable-debug is not recommended for production use
	use debug && myconf="${myconf} --enable-debug=yes"

	# need libdir here to avoid a double slash in a path that libtool doesn't
	# grok so well during install (// between $EPREFIX and usr ...)
	econf --libdir="${EPREFIX}/usr/$(get_libdir)" ${myconf}
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "tests failed"
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die "Installation failed"

	set_gtk2_confdir
	dodir ${GTK2_CONFDIR}
	keepdir ${GTK2_CONFDIR}

	# see bug #133241
	echo 'gtk-fallback-icon-theme = "gnome"' > "${T}/gtkrc"
	insinto ${GTK2_CONFDIR}
	doins "${T}"/gtkrc

	# Enable xft in environment as suggested by <utx@gentoo.org>
	echo "GDK_USE_XFT=1" > "${T}"/50gtk2
	doenvd "${T}"/50gtk2

	dodoc AUTHORS ChangeLog* HACKING NEWS* README* || die "dodoc failed"

	# This has to be removed, because it's multilib specific; generated in
	# postinst
	rm "${ED}etc/gtk-2.0/gtk.immodules"

	# add -framework Carbon to the .pc files
	use aqua && for i in gtk+-2.0.pc gtk+-quartz-2.0.pc gtk+-unix-print-2.0.pc; do
		sed -i -e "s:Libs\: :Libs\: -framework Carbon :" "${ED%/}"/usr/lib/pkgconfig/$i || die "sed failed"
	done

	python_convert_shebangs 2 "${D}"usr/bin/gtk-builder-convert

	prep_ml_binaries $(find "${D}"usr/bin/ -type f $(for i in $(get_install_abis); do echo "-not -name "*-$i""; done)| sed "s!${D}!!g")
}

multilib-native_pkg_postinst_internal() {
	set_gtk2_confdir

	if [ -d "${EROOT%/}${GTK2_CONFDIR}" ]; then
		gtk-query-immodules-2.0  > "${EROOT%/}${GTK2_CONFDIR}/gtk.immodules"
	else
		ewarn "The destination path ${EROOT%/}${GTK2_CONFDIR} doesn't exist;"
		ewarn "to complete the installation of GTK+, please create the"
		ewarn "directory and then manually run:"
		ewarn "  cd ${EROOT%/}${GTK2_CONFDIR}"
		ewarn "  gtk-query-immodules-2.0  > gtk.immodules"
	fi

	if [ -e "${EROOT%/}"/usr/lib/gtk-2.0/2.[^1]* ]; then
		elog "You need to rebuild ebuilds that installed into" "${EROOT%/}"/usr/lib/gtk-2.0/2.[^1]*
		elog "to do that you can use qfile from portage-utils:"
		elog "emerge -va1 \$(qfile -qC ${EPREFIX}/usr/lib/gtk-2.0/2.[^1]*)"
	fi

	elog "Please install app-text/evince for print preview functionality."
	elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
	elog "add it to your gtkrc."
}
