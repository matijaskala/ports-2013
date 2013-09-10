# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"

inherit python

DESCRIPTION="Virtual for simplejson and json Python modules"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="*"
IUSE="external"

DEPEND=""
RDEPEND="$(python_abi_depend -i "2.5" dev-python/simplejson)
	external? ( $(python_abi_depend -e "2.5 3.1 3.2" dev-python/simplejson) )"
