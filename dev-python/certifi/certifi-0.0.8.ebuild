# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils

DESCRIPTION="Mozilla's SSL Certs."
HOMEPAGE="http://python-requests.org/ http://pypi.python.org/pypi/certifi"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND=""
RDEPEND="app-misc/ca-certificates"

src_install() {
	distutils_src_install

	create_cacert.pem_symlink() {
		# Overwrite bundled certificates with a symlink.
		dosym "${EPREFIX}/etc/ssl/certs/ca-certificates.crt" "$(python_get_sitedir -b)/certifi/cacert.pem"
	}
	python_execute_function -q create_cacert.pem_symlink
}
