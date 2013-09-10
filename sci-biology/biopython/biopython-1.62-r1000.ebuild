# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils

DESCRIPTION="Python modules for computational molecular biology"
HOMEPAGE="http://biopython.org/ https://pypi.python.org/pypi/biopython"
SRC_URI="http://www.biopython.org/DIST/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="*"
IUSE="mysql postgres reportlab"

DEPEND="$(python_abi_depend -e "*-jython *-pypy-*" dev-python/numpy)
	mysql? ( $(python_abi_depend -e "3.* *-jython" dev-python/mysql-python) )
	postgres? ( $(python_abi_depend -e "*-jython *-pypy-*" dev-python/psycopg:2) )
	reportlab? ( $(python_abi_depend -e "3.* *-jython" dev-python/reportlab) )"
RDEPEND="${DEPEND}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
DOCS="CONTRIB DEPRECATED NEWS README"
PYTHON_MODULES="Bio BioSQL"

src_test() {
	testing() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			cd build/py$(python_get_version -l)/Tests
		else
			cd Tests
		fi

		python_execute PYTHONPATH="$(ls -d ../build/lib*)" "$(PYTHON)" run_tests.py
	}
	python_execute_function --nonfatal -s testing
}

src_install() {
	distutils_src_install

	insinto /usr/share/doc/${PF}
	doins -r Doc/*
	insinto /usr/share/${PN}
	cp -r --preserve=mode Scripts Tests "${ED}usr/share/${PN}" || die "Installation of shared files failed"
}
