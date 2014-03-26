# Copyright 2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

BRANCH_RANGE="2"
BRANCH=$(get_version_component_range 1-${BRANCH_RANGE})
SRC_SUFFIX="tar.gz"
SRC_URI="https://launchpad.net/${PN}/${BRANCH}/${PV}/+download/${P}.${SRC_SUFFIX}"
