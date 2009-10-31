# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/www/viewcvs.gentoo.org/raw_cvs/gentoo-x86/dev-lang/python/python-2.6.3.ebuild,v 1.7 2009/10/24 14:35:31 alexxy Exp $

EAPI="2"

inherit autotools eutils flag-o-matic multilib pax-utils python toolchain-funcs versionator multilib-native
MULTILIB_IN_SOURCE_BUILD="yes"

# We need this so that we don't depend on python.eclass
PYVER_MAJOR="$(get_major_version)"
PYVER_MINOR="$(get_version_component_range 2)"
PYVER="${PYVER_MAJOR}.${PYVER_MINOR}"

MY_P="Python-${PV}"
S="${WORKDIR}/${MY_P}"

PATCHSET_REVISION="0"

DESCRIPTION="Python is an interpreted, interactive, object-oriented programming language."
HOMEPAGE="http://www.python.org/"
SRC_URI="http://www.python.org/ftp/python/${PV}/${MY_P}.tar.bz2
	mirror://gentoo/python-gentoo-patches-${PV}$([[ "${PATCHSET_REVISION}" != "0" ]] && echo "-r${PATCHSET_REVISION}").tar.bz2"

LICENSE="PSF-2.2"
SLOT="2.6"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="-berkdb build doc elibc_uclibc examples gdbm ipv6 +ncurses +readline sqlite ssl +threads tk ucs2 wininst +xml"

# NOTE: dev-python/{elementtree,celementtree,pysqlite,ctypes}
#       do not conflict with the ones in python proper. - liquidx

RDEPEND=">=app-admin/eselect-python-20090606
		>=sys-libs/zlib-1.1.3[lib32?]
		virtual/libffi[lib32?]
		virtual/libintl
		!build? (
			berkdb? ( || (
				sys-libs/db:4.7[lib32?]
				sys-libs/db:4.6[lib32?]
				sys-libs/db:4.5[lib32?]
				sys-libs/db:4.4[lib32?]
				sys-libs/db:4.3[lib32?]
				sys-libs/db:4.2[lib32?]
			) )
			doc? ( dev-python/python-docs:${SLOT} )
			gdbm? ( sys-libs/gdbm[lib32?] )
			ncurses? ( >=sys-libs/ncurses-5.2[lib32?]
						readline? ( >=sys-libs/readline-4.1[lib32?] ) )
			sqlite? ( >=dev-db/sqlite-3[lib32?] )
			ssl? ( dev-libs/openssl[lib32?] )
			tk? ( >=dev-lang/tk-8.0[lib32?] )
			xml? ( >=dev-libs/expat-2[lib32?] )
		)"
DEPEND="${RDEPEND}
		dev-util/pkgconfig[lib32?]"
RDEPEND+=" !build? ( app-misc/mime-types )"
PDEPEND="${DEPEND} app-admin/python-updater"

PROVIDE="virtual/python"

multilib-native_pkg-setup_internal() {
	if use berkdb; then
		ewarn "\"bsddb\" module is out-of-date and no longer maintained inside dev-lang/python. It has"
		ewarn "been additionally removed in Python 3. You should use external, still maintained \"bsddb3\""
		ewarn "module provided by dev-python/bsddb3 which supports both Python 2 and Python 3."
	fi

	if ! has_version "=dev-lang/python-3*"; then
		elog "It is highly recommended to additionally install Python 3, but without configuring Python wrapper to use Python 3."
	fi
}

multilib-native_src_prepare_internal() {
	# Ensure that internal copies of expat and libffi aren't used.
	rm -fr Modules/expat
	rm -fr Modules/_ctypes/libffi*

	if tc-is-cross-compiler; then
		epatch "${FILESDIR}/python-2.5-cross-printf.patch"
		epatch "${FILESDIR}/python-2.6-chflags-cross.patch"
		epatch "${FILESDIR}/python-2.6-test-cross.patch"
	else
		rm "${WORKDIR}/${PV}"/*_all_crosscompile.patch
	fi

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/${PV}"

	sed -i -e "s:@@GENTOO_LIBDIR@@:$(get_libdir):g" \
		Lib/distutils/command/install.py \
		Lib/distutils/sysconfig.py \
		Lib/site.py \
		Makefile.pre.in \
		Modules/Setup.dist \
		Modules/getpath.c \
		setup.py || die "sed failed to replace @@GENTOO_LIBDIR@@"

	# Fix os.utime() on hppa. utimes it not supported but unfortunately reported as working - gmsoft (22 May 04)
	# PLEASE LEAVE THIS FIX FOR NEXT VERSIONS AS IT'S A CRITICAL FIX !!!
	[[ "${ARCH}" == "hppa" ]] && sed -e "s/utimes //" -i "${S}/configure"

	if ! use wininst; then
		# Remove Microsoft Windows executables.
		rm Lib/distutils/command/wininst-*.exe
	fi

	# Don't silence output of setup.py.
	sed -e "/setup\.py -q build/d" -i Makefile.pre.in

	# Fix OtherFileTests.testStdin() not to assume
	# that stdin is a tty for bug #248081.
	sed -e "s:'osf1V5':'osf1V5' and sys.stdin.isatty():" -i Lib/test/test_file.py || die "sed failed"

	eautoreconf
}

multilib-native_src_configure_internal() {
	# Disable extraneous modules with extra dependencies.
	if use build; then
		export PYTHON_DISABLE_MODULES="dbm _bsddb gdbm _curses _curses_panel readline _sqlite3 _tkinter _elementtree pyexpat"
		export PYTHON_DISABLE_SSL="1"
	else
		# dbm module can be linked against berkdb or gdbm.
		# Defaults to gdbm when both are enabled, #204343.
		local disable
		use berkdb   || use gdbm || disable+=" dbm"
		use berkdb   || disable+=" _bsddb"
		use gdbm     || disable+=" gdbm"
		use ncurses  || disable+=" _curses _curses_panel"
		use readline || disable+=" readline"
		use sqlite   || disable+=" _sqlite3"
		use ssl      || export PYTHON_DISABLE_SSL="1"
		use tk       || disable+=" _tkinter"
		use xml      || disable+=" _elementtree pyexpat" # _elementtree uses pyexpat.
		export PYTHON_DISABLE_MODULES="${disable}"

		if ! use xml; then
			ewarn "You have configured Python without XML support."
			ewarn "This is NOT a recommended configuration as you"
			ewarn "may face problems parsing any XML documents."
		fi
	fi

	if [[ -n "${PYTHON_DISABLE_MODULES}" ]]; then
		einfo "Disabled modules: ${PYTHON_DISABLE_MODULES}"
	fi

	export OPT="${CFLAGS}"

	filter-flags -malign-double

	[[ "${ARCH}" == "alpha" ]] && append-flags -fPIC

	# https://bugs.gentoo.org/show_bug.cgi?id=50309
	if is-flag -O3; then
		is-flag -fstack-protector-all && replace-flags -O3 -O2
		use hardened && replace-flags -O3 -O2
	fi

	if tc-is-cross-compiler; then
		OPT="-O1" CFLAGS="" LDFLAGS="" CC="" \
		./configure --{build,host}=${CBUILD} || die "cross-configure failed"
		emake python Parser/pgen || die "cross-make failed"
		mv python hostpython
		mv Parser/pgen Parser/hostpgen
		make distclean
		sed -i \
			-e "/^HOSTPYTHON/s:=.*:=./hostpython:" \
			-e "/^HOSTPGEN/s:=.*:=./Parser/hostpgen:" \
			Makefile.pre.in || die "sed failed"
	fi

	# Export CXX so it ends up in /usr/lib/python2.X/config/Makefile.
	tc-export CXX

	# Set LDFLAGS so we link modules with -lpython2.6 correctly.
	# Needed on FreeBSD unless Python 2.6 is already installed.
	# Please query BSD team before removing this!
	append-ldflags "-L."

	econf \
		--with-fpectl \
		--enable-shared \
		$(use_enable ipv6) \
		$(use_with threads) \
		$(use ucs2 && echo "--enable-unicode=ucs2" || echo "--enable-unicode=ucs4") \
		--infodir='${prefix}'/share/info \
		--mandir='${prefix}'/share/man \
		--with-libc='' \
		--with-system-ffi
}

multilib-native_src_test_internal() {
	# Tests won't work when cross compiling.
	if tc-is-cross-compiler; then
		elog "Disabling tests due to crosscompiling."
		return
	fi

	# Byte compiling should be enabled here.
	# Otherwise test_import fails.
	python_enable_pyc

	# Skip all tests that fail during emerge but pass without emerge:
	# (See bug #67970)
	local skip_tests="distutils minidom pyexpat sax tcl"

	# test_ctypes fails with PAX kernel (bug #234498).
	host-is-pax && skip_tests+=" ctypes"

	for test in ${skip_tests}; do
		mv "${S}/Lib/test/test_${test}.py" "${T}"
	done

	# Rerun failed tests in verbose mode (regrtest -w).
	EXTRATESTOPTS="-w" make test || die "make test failed"

	for test in ${skip_tests}; do
		mv "${T}"/test_${test}.py "${S}"/Lib/test/test_${test}.py
	done

	elog "The following tests have been skipped:"
	for test in ${skip_tests}; do
		elog "test_${test}.py"
	done

	elog "If you'd like to run them, you may:"
	elog "cd /usr/$(get_libdir)/python${PYVER}/test"
	elog "and run the tests separately."
}

multilib-native_src_install_internal() {
	emake DESTDIR="${D}" altinstall maninstall || die "emake altinstall maninstall failed"

	mv "${D}usr/bin/python${PYVER}-config" "${D}usr/bin/python-config-${PYVER}"
	if [[ $(number_abis) -gt 1 ]] && ! is_final_abi; then
		mv "${D}usr/bin/python${PYVER}" "${D}usr/bin/python${PYVER}-${ABI}"
	fi

	# Fix collisions between different slots of Python.
	mv "${D}usr/bin/2to3" "${D}usr/bin/2to3-${PYVER}"
	mv "${D}usr/bin/pydoc" "${D}usr/bin/pydoc${PYVER}"
	mv "${D}usr/bin/idle" "${D}usr/bin/idle${PYVER}"
	mv "${D}usr/share/man/man1/python.1" "${D}usr/share/man/man1/python${PYVER}.1"
	rm -f "${D}usr/bin/smtpd.py"

	# Fix the OPT variable so that it doesn't have any flags listed in it.
	# Prevents the problem with compiling things with conflicting flags later.
	sed -e "s:^OPT=.*:OPT=-DNDEBUG:" -i "${D}usr/$(get_libdir)/python${PYVER}/config/Makefile"

	if use build; then
		rm -fr "${D}usr/$(get_libdir)/python${PYVER}/"{bsddb,email,lib-tk,sqlite3,test}
	else
		use elibc_uclibc && rm -fr "${D}usr/$(get_libdir)/python${PYVER}/"{bsddb/test,test}
		use berkdb || rm -fr "${D}usr/$(get_libdir)/python${PYVER}/"{bsddb,test/test_bsddb*}
		use sqlite || rm -fr "${D}usr/$(get_libdir)/python${PYVER}/"{sqlite3,test/test_sqlite*}
		use tk || rm -fr "${D}usr/$(get_libdir)/python${PYVER}/lib-tk"
	fi

	use threads || rm -fr "${D}usr/$(get_libdir)/python${PYVER}/multiprocessing"

	prep_ml_includes usr/include/python${PYVER}

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}/Tools" || die "doins failed"
	fi

	newinitd "${FILESDIR}/pydoc.init" pydoc-${SLOT}
	newconfd "${FILESDIR}/pydoc.conf" pydoc-${SLOT}

	# Installs empty directory.
	rmdir "${D}usr/$(get_libdir)/${PN}${PYVER}/lib-old"
}

multilib-native_pkg_preinst_internal() {
	if has_version "<${CATEGORY}/${PN}-${SLOT}" && ! has_version ">=${CATEGORY}/${PN}-${SLOT}_alpha"; then
		python_updater_warning="1"
	fi
}

eselect_python_update() {
	local ignored_python_slots
	[[ "$(eselect python show)" == "python2."* ]] && ignored_python_slots="--ignore 3.0 --ignore 3.1 --ignore 3.2"

	# Create python2 symlink.
	eselect python update --ignore 3.0 --ignore 3.1 --ignore 3.2 > /dev/null

	eselect python update ${ignored_python_slots}
}

multilib-native_pkg_postinst_internal() {
	eselect_python_update

	python_mod_optimize -x "(site-packages|test)" /usr/$(get_libdir)/python${PYVER}

	if [[ "${python_updater_warning}" == "1" ]]; then
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
		ewarn "You have just upgraded from an older version of Python."
		ewarn "You should run 'python-updater \${options}' to rebuild Python modules."
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
		ebeep 12
	fi
}

multilib-native_pkg_postrm_internal() {
	eselect_python_update

	python_mod_cleanup /usr/$(get_libdir)/python${PYVER}
}
