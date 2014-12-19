# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

if [[ -z ${UVER_PREFIX} ]]
then
	UVER_PREFIX=${PV##*_p}
	[[ ${UVER_PREFIX} == ${PV} ]] && UVER_PREFIX=
	if [[ -n ${UVER_PREFIX} ]]
	then
		PV=${PV%_p*}
		[[ ${PV} == *14.04* ]] && UVER_RELEASE=14.04
		[[ ${PV} == *14.10* ]] && UVER_RELEASE=14.10
		[[ ${PV} == *15.04* ]] && UVER_RELEASE=15.04
		[[ ${PV} == *.14.04 ]] && PV=${PV%.14.04}
		[[ ${PV} == *.14.10 ]] && PV=${PV%.14.10}
		[[ ${PV} == *.15.04 ]] && PV=${PV%.15.04}
		if [[ -n ${UVER_RELEASE} ]]
		then
			UVER_PREFIX="+${UVER_RELEASE}.${UVER_PREFIX}"
		else
			UVER_PREFIX="+${UVER_PREFIX}"
		fi
		P=${PN}-${PV}
	fi
fi

UURL="https://launchpad.net/ubuntu/+archive/primary/+files/"
: ${SRC_SUFFIX:="orig.tar.gz"}
SRC_URI="${UURL}${PN}_${PV}${UVER_PREFIX}.${SRC_SUFFIX}"
RESTRICT="mirror"

S="${WORKDIR}/${P}${UVER_PREFIX}"
