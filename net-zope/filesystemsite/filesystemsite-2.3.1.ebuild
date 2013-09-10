# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.* *-jython *-pypy-*"

inherit distutils

MY_PN="Products.FileSystemSite"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="File system based site"
HOMEPAGE="http://infrae.com/download/silva_all/FileSystemSite"
SRC_URI="${HOMEPAGE}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD ZPL"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[Products])
	$(python_abi_depend dev-python/restrictedpython)
	$(python_abi_depend net-zope/accesscontrol)
	$(python_abi_depend net-zope/acquisition)
	$(python_abi_depend net-zope/datetime)
	$(python_abi_depend net-zope/extensionclass)
	$(python_abi_depend net-zope/externalmethod)
	$(python_abi_depend net-zope/persistence)
	$(python_abi_depend net-zope/pythonscripts)
	$(python_abi_depend net-zope/zexceptions)
	$(python_abi_depend net-zope/zlog)
	$(python_abi_depend net-zope/zope)
	$(python_abi_depend net-zope/zope.component)
	$(python_abi_depend net-zope/zope.contentprovider)
	$(python_abi_depend net-zope/zope.contenttype)
	$(python_abi_depend net-zope/zope.event)
	$(python_abi_depend net-zope/zope.interface)
	$(python_abi_depend net-zope/zope.location)
	$(python_abi_depend net-zope/zope.schema)
	$(python_abi_depend net-zope/zope.tales)
	$(python_abi_depend net-zope/zsqlmethods)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

S="${WORKDIR}/${MY_P}"

DOCS="Products/FileSystemSite/HISTORY.txt README.txt"
PYTHON_MODULES="${MY_PN/.//}"
