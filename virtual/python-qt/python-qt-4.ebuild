# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"

inherit python

DESCRIPTION="Virtual for PyQt4 and PySide Python modules"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="4"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="X declarative help kde multimedia opengl phonon script scripttools sql svg webkit xmlpatterns"

DEPEND=""
RDEPEND="$(for PYTHON_ABI in "${_PYTHON_LOCALLY_SUPPORTED_ABIS[@]}"; do
	if has "${PYTHON_ABI}" 2.5 3.1; then
		echo "python_abis_${PYTHON_ABI}? ( dev-python/PyQt4[$(printf "%s?," ${IUSE})python_abis_${PYTHON_ABI}] )"
	else
		echo "python_abis_${PYTHON_ABI}? ( || (
	dev-python/PyQt4[$(printf "%s?," ${IUSE})python_abis_${PYTHON_ABI}]
	dev-python/pyside[$(printf "%s?," ${IUSE})python_abis_${PYTHON_ABI}]
) )"
	fi
done)"
