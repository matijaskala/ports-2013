# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"

inherit python

DESCRIPTION="Wrapper package for dev-python/pyparsing"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="*"
IUSE=""
REQUIRED_USE="!python_abis_2.5 !python_abis_2.5-jython"

DEPEND=""
RDEPEND="$(python_abi_depend -e "2.5" dev-python/pyparsing)"
