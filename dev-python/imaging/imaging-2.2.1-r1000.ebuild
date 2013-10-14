# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[{*-cpython}tk?]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"

inherit distutils eutils multilib

MY_PN="Pillow"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python Imaging Library - Pillow (fork of PIL)"
HOMEPAGE="https://github.com/python-imaging/Pillow https://pypi.python.org/pypi/Pillow"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="HPND"
SLOT="0"
KEYWORDS="*"
IUSE="X doc examples jpeg lcms scanner tiff tk truetype webp zlib"

RDEPEND="X? ( x11-misc/xdg-utils )
	jpeg? ( virtual/jpeg )
	lcms? ( media-libs/lcms:0= )
	scanner? ( media-gfx/sane-backends:0= )
	tiff? ( media-libs/tiff:0= )
	truetype? ( media-libs/freetype:2= )
	webp? ( >=media-libs/libwebp-0.3:0= )
	zlib? ( sys-libs/zlib:0= )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES.rst CONTRIBUTORS.rst README.rst"

pkg_setup() {
	PYTHON_MODULES="PIL $(use scanner && echo sane.py)"
	python_pkg_setup
}

src_prepare() {
	distutils_src_prepare

	epatch "${FILESDIR}/${P}-delete_hardcoded_paths.patch"
	epatch "${FILESDIR}/${PN}-2.1.0-libm_linking.patch"
	epatch "${FILESDIR}/${PN}-2.0.0-use_xdg-open.patch"

	local feature
	for feature in jpeg lcms tiff truetype:freetype webp webp:webpmux zlib; do
		if ! use ${feature%:*}; then
			sed -e "s/if feature\.want('${feature#*:}'):/if False:/" -i setup.py
		fi
	done

	if ! use tk; then
		sed -e "s/import _tkinter/raise ImportError/" -i setup.py
	fi
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		PYTHONPATH="$(ls -d ../build-$(PYTHON -f --ABI)/lib*)" emake html
		popd > /dev/null
	fi

	if use scanner; then
		pushd Sane > /dev/null
		distutils_src_compile
		popd > /dev/null
	fi
}

src_test() {
	tests() {
		python_execute PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" selftest.py --installed || return
		python_execute PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" Tests/run.py --installed || return
	}
	python_execute_function tests
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -f "${ED}$(python_get_sitedir)/PIL/tests.py"
	}
	python_execute_function -q delete_tests

	local module
	for module in PIL/*.py; do
		module="${module#PIL/}"
		module="${module%.py}"
		[[ "${module}" =~ ^(__init__|_binary|JpegPresets|WebPImagePlugin|tests)$ ]] && continue
		PYTHON_MODULES+=" ${module}.py"
	done

	generate_compatibility_modules() {
		local module
		for module in PIL/*.py; do
			module="${module#PIL/}"
			module="${module%.py}"
			[[ "${module}" =~ ^(__init__|_binary|JpegPresets|WebPImagePlugin|tests)$ ]] && continue
			dodir "$(python_get_sitedir)"
			cat << EOF > "${ED}$(python_get_sitedir)/${module}.py"
def _warning():
	import warnings
	message = "'%s' module is deprecated. Use 'PIL.%s' module instead." % (__name__, __name__)
	warnings.filterwarnings("default", message, DeprecationWarning)
	warnings.warn(message, DeprecationWarning)
_warning()
del _warning

from PIL.${module} import *
EOF
		done
	}
	python_execute_function -q generate_compatibility_modules

	if use doc; then
		dohtml -r docs/_build/html/
	fi

	if use scanner; then
		pushd Sane > /dev/null
		docinto sane
		DOCS="CHANGES sanedoc.txt" distutils_src_install
		popd > /dev/null
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins Scripts/*

		if use scanner; then
			insinto /usr/share/doc/${PF}/examples/sane
			doins Sane/demo_pil.py
		fi
	fi
}
