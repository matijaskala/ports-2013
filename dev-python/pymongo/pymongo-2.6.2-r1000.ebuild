# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Python driver for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-python-driver https://pypi.python.org/pypi/pymongo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc gevent mod_wsgi"

RDEPEND="dev-db/mongodb
	gevent? ( $(python_abi_depend -i "2.*-cpython" dev-python/gevent) )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )"

PYTHON_MODULES="bson gridfs pymongo"

src_prepare() {
	distutils_src_prepare
	sed -e "/^sys.path\[0:0\] =/d" -i doc/conf.py
	rm -f setup.cfg

	preparation() {
		mkdir build-${PYTHON_ABI} || return
		cp -r test build-${PYTHON_ABI} || return
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			2to3-${PYTHON_ABI} -nw --no-diffs build-${PYTHON_ABI}/test || return
		fi
	}
	python_execute_function preparation
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		python_execute PYTHONPATH="$(ls -d build-$(PYTHON -f --ABI)/lib*):." sphinx-build doc html || die "Generation of documentation failed"
	fi
}

python_execute_nosetests_pre_hook() {
	mkdir -p "${T}/tests-${PYTHON_ABI}/mongo.db"
	python_execute mongod --dbpath "${T}/tests-${PYTHON_ABI}/mongo.db" --fork --logpath "${T}/tests-${PYTHON_ABI}/mongo.log"
}

python_execute_nosetests_post_hook() {
	killall -u "$(id -nu)" mongod
	rm -fr "${T}/tests-${PYTHON_ABI}/mongo.db"
}

src_test() {
	python_execute_nosetests -e -P '$(ls -d build-${PYTHON_ABI}/lib*)' -- -P -w 'build-${PYTHON_ABI}/test'
}

src_install() {
	# Extension modules should be disabled for mod_wsgi.
	# http://api.mongodb.org/python/current/faq.html#does-pymongo-work-with-mod-wsgi
	distutils_src_install $(use mod_wsgi && echo --no_ext)

	if use doc; then
		dohtml -r html/
	fi
}
