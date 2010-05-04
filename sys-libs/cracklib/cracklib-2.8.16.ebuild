# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/cracklib/cracklib-2.8.16.ebuild,v 1.1 2010/04/30 13:02:14 vapier Exp $

EAPI="2"

inherit eutils toolchain-funcs multilib libtool multilib-native

MY_P=${P/_}
DESCRIPTION="Password Checking Library"
HOMEPAGE="http://sourceforge.net/projects/cracklib"
SRC_URI="mirror://sourceforge/cracklib/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="nls python"

DEPEND="python? ( <dev-lang/python-3[lib32?] )"

S=${WORKDIR}/${MY_P}

multilib-native_pkg_setup_internal() {
	# workaround #195017
	if has unmerge-orphans ${FEATURES} && has_version "<${CATEGORY}/${PN}-2.8.10" ; then
		eerror "Upgrade path is broken with FEATURES=unmerge-orphans"
		eerror "Please run: FEATURES=-unmerge-orphans emerge cracklib"
		die "Please run: FEATURES=-unmerge-orphans emerge cracklib"
	fi
}

multilib-native_src_prepare_internal() {
	epatch "${FILESDIR}"/${PN}-2.8.13-python-linkage.patch #246747
	sed -i '/PYTHON/s:\(print\) \([^"]*\):\1(\2):' configure #302908
	elibtoolize #269003
}

multilib-native_src_configure_internal() {
	econf \
		--with-default-dict='$(libdir)/cracklib_dict' \
		$(use_enable nls) \
		$(use_with python) \
		|| die
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" install || die "make install failed"
	rm -r "${D}"/usr/share/cracklib

	find "${D}" -name '_cracklibmodule.*a' -exec rm {} + #316495

	# move shared libs to /
	gen_usr_ldscript -a crack

	insinto /usr/share/dict
	doins dicts/cracklib-small || die "word dict"

	dodoc AUTHORS ChangeLog NEWS README*
}

multilib-native_pkg_postinst_internal() {
	if [[ ${ROOT} == "/" ]] ; then
		ebegin "Regenerating cracklib dictionary"
		create-cracklib-dict /usr/share/dict/* > /dev/null
		eend $?
	fi
}
