# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"

inherit python

DESCRIPTION="Wrapper package for dev-python/imaging"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="*"
IUSE="tk"
REQUIRED_USE="!python_abis_2.5"

DEPEND=""
RDEPEND="$(python_abi_depend -e "2.5" dev-python/imaging)"
