# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

UURL="https://launchpad.net/ubuntu/+archive/primary/+files/"
: ${SRC_SUFFIX:="tar.gz"}
SRC_URI="${UURL}${PN}_${PV}${UVER_PREFIX}.orig.${SRC_SUFFIX}"
RESTRICT="mirror"

S="${WORKDIR}/${P}${UVER_PREFIX}"
