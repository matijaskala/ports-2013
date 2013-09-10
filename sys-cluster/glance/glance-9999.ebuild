# Distributed under the terms of the GNU General Public License v2

EAPI=4-python

PYTHON_MULTIPLE_ABIS=1
PYTHON_RESTRICTED_ABIS="2.[45] 3.* *-jython *-pypy-*"

inherit git-2 distutils

DESCRIPTION="Provides services for discovering, registering, and retrieving
virtual machine images. Glance has a RESTful API that allows querying of VM
image metadata as well as retrieval of the actual image."
HOMEPAGE="https://launchpad.net/glance"
EGIT_REPO_URI="https://github.com/openstack/glance.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND="${DEPEND} $(python_abi_depend dev-python/eventlet dev-python/iso8601 dev-python/webob dev-python/httplib2 dev-python/routes dev-python/paste dev-python/pastedeploy dev-python/pyxattr dev-python/kombu dev-python/sqlalchemy-migrate)"

src_install() {
	distutils_src_install
	for i in api registry scrubber; do
		newinitd "${FILESDIR}/glance-all.initd" glance-${i}
	done

	diropts -m 0750
	dodir /var/run/glance /var/log/glance /var/lock/glance

	insinto /etc/glance
	doins ${S}/etc/*
	sed -ie 'sX^sql_connection.*$Xsql_connection = sqlite:////etc/glance/glance.sqliteX' ${D}/etc/glance/glance-registry.conf || die
}
