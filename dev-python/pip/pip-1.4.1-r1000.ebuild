# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"

inherit bash-completion-r1 distutils

DESCRIPTION="A tool for installing and managing Python packages."
HOMEPAGE="http://www.pip-installer.org/ https://github.com/pypa/pip https://pypi.python.org/pypi/pip"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="zsh-completion"

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND="${DEPEND}"

DOCS="AUTHORS.txt CHANGES.txt docs/*.rst"

src_prepare() {
	distutils_src_prepare

	# Disable versioning of pip script to avoid collision with versioning performed by python_merge_intermediate_installation_images().
	sed -e "/console_scripts=/s/, 'pip-%s=pip:main' % sys.version\[:3\]//" -i setup.py || die "sed failed"
}

src_install() {
	distutils_src_install

	python_generate_wrapper_scripts -E -f -q "${ED}usr/bin/pip"

	"$(PYTHON -f)" pip/runner.py completion --bash > pip.bash_completion || die "Generation of bash completion file failed"
	newbashcomp pip.bash_completion pip

	if use zsh-completion; then
		"$(PYTHON -f)" pip/runner.py completion --zsh > pip.zsh_completion || die "Generation of zsh completion file failed"
		insinto /usr/share/zsh/site-functions
		newins pip.zsh_completion _pip
	fi
}
