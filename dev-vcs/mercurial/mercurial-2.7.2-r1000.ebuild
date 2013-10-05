# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[threads]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython *-pypy-*"

inherit bash-completion-r1 elisp-common eutils distutils

DESCRIPTION="Scalable distributed SCM"
HOMEPAGE="http://mercurial.selenic.com/"
SRC_URI="http://mercurial.selenic.com/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="bugzilla emacs gpg test tk zsh-completion"

RDEPEND="app-misc/ca-certificates
	bugzilla? ( $(python_abi_depend dev-python/mysql-python) )
	gpg? ( app-crypt/gnupg )
	tk? ( dev-lang/tk )
	zsh-completion? ( app-shells/zsh )"
DEPEND="emacs? ( virtual/emacs )
	$([[ ${PV} == 9999 ]] && python_abi_depend dev-python/docutils)
	test? (
		app-arch/unzip
		$(python_abi_depend dev-python/pygments)
	)"

PYTHON_CFLAGS=(
	"2.* + -fno-strict-aliasing"
	"* - -ftracer -ftree-vectorize"
)

PYTHON_MODULES="${PN} hgext"
SITEFILE="70${PN}-gentoo.el"

src_prepare() {
	distutils_src_prepare
	# fix up logic that won't work in Gentoo Prefix (also won't outside in
	# certain cases), bug #362891
	sed -i -e 's:xcodebuild:nocodebuild:' setup.py || die
}

src_compile() {
	distutils_src_compile

	if [[ ${PV} == 9999 ]]; then
		emake doc
	fi

	if use emacs; then
		pushd contrib > /dev/null || die
		elisp-compile mercurial.el || die "elisp-compile failed!"
		popd > /dev/null || die
	fi

	rm -rf contrib/{win32,macosx} || die
}

src_install() {
	distutils_src_install

	newbashcomp contrib/bash_completion hg

	if use emacs; then
		elisp-install ${PN} contrib/mercurial.el* || die "elisp-install failed!"
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		newins contrib/zsh_completion _hg
	fi

	dodoc CONTRIBUTORS
	cp hgweb*.cgi "${ED}"/usr/share/doc/${PF}/ || die

	dobin hgeditor
	dobin contrib/hgk
	python_install_executables contrib/hg-ssh

	rm -fr contrib/{*.el,bash_completion,buildrpm,hg-ssh,hgk,mercurial.spec,plan9,wix,zsh_completion} || die

	dodoc -r contrib
	docompress -x /usr/share/doc/${PF}/contrib
	doman doc/*.?

	cat > "${T}/80mercurial" <<-EOF
HG="${EPREFIX}/usr/bin/hg"
EOF
	doenvd "${T}/80mercurial"

	insinto /etc/mercurial/hgrc.d
	doins "${FILESDIR}/cacerts.rc"
}

src_test() {
	cd "${S}/tests/" || die
	rm -rf *svn* || die					# Subversion tests fail with 1.5
	rm -f test-archive* || die			# Fails due to verbose tar output changes
	rm -f test-convert-baz* || die		# GNU Arch baz
	rm -f test-convert-cvs* || die		# CVS
	rm -f test-convert-darcs* || die	# Darcs
	rm -f test-convert-git* || die		# git
	rm -f test-convert-mtn* || die		# monotone
	rm -f test-convert-tla* || die		# GNU Arch tla
	rm -f test-doctest* || die			# doctest always fails with python 2.5.x
	rm -f test-largefiles* || die		# tends to time out
	if [[ ${EUID} -eq 0 ]]; then
		einfo "Removing tests which require user privileges to succeed"
		rm -f test-command-template* || die	# Test is broken when run as root
		rm -f test-convert* || die			# Test is broken when run as root
		rm -f test-lock-badness* || die		# Test is broken when run as root
		rm -f test-permissions* || die		# Test is broken when run as root
		rm -f test-pull-permission* || die	# Test is broken when run as root
		rm -f test-clone-failure* || die
		rm -f test-journal-exists* || die
		rm -f test-repair-strip* || die
	fi

	testing() {
		local testdir="${T}/tests-${PYTHON_ABI}"
		rm -rf "${testdir}" || die
		"$(PYTHON)" run-tests.py --tmpdir="${testdir}"
	}
	python_execute_function testing
}

pkg_postinst() {
	distutils_pkg_postinst
	use emacs && elisp-site-regen

	elog "If you want to convert repositories from other tools using convert"
	elog "extension please install correct tool:"
	elog "  dev-vcs/cvs"
	elog "  dev-vcs/darcs"
	elog "  dev-vcs/git"
	elog "  dev-vcs/monotone"
	elog "  dev-vcs/subversion"
}

pkg_postrm() {
	distutils_pkg_postrm
	use emacs && elisp-site-regen
}
