# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: geek.eclass
# @MAINTAINER:
# Matija Skala <mskala@gmx.com>
# @AUTHOR:
# Matija Skala <mskala@gmx.com>
# @BLURB: Eclass for combining VCS with tarballs
# @DESCRIPTION:
# Clone a git repository, then apply its contents to source code extracted from tarballs

: ${GEEK_STORE_DIR:="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/geek"}

geek_prepare_storedir() {
	[[ -d ${GEEK_STORE_DIR} ]] || addwrite /
	addwrite "${GEEK_STORE_DIR}"
}

geek_get_source_repo_path() {
	local uper=$(echo "$1" | tr '[:lower:]' '[:upper:]')
	local REPO=${uper}_REPO_URI
	if [[ ${!REPO% -> *} == ${!REPO} ]] ; then
		echo "${GEEK_STORE_DIR}/$1"
	else
		echo "${GEEK_STORE_DIR}/${!REPO#* -> }"
	fi
}

geek_fetch() {
	local uper=$(echo "$1" | tr '[:lower:]' '[:upper:]')
	local BRANCH=${uper}_BRANCH
	local REPO=${uper}_REPO_URI
	[[ -z ${!REPO} ]] && return
	local CSD="$(geek_get_source_repo_path "$1")"
	local REPO_URI="${!REPO% -> *}"
	if [[ -d ${CSD} ]] ; then
		pushd "${CSD}" > /dev/null || die
		[[ -e .git ]] && git pull --all --quiet
		[[ -e .svn ]] && svn update --quiet
		popd > /dev/null || die
	elif [[ ${REPO_URI} == svn:* ]] ; then
		svn checkout "${REPO_URI}" "${CSD}"
	elif [[ -z ${!BRANCH} ]] ; then
		git clone --depth=1 "${REPO_URI}" "${CSD}"
	else
		git clone --depth=1 -b "${!BRANCH}" "${REPO_URI}" "${CSD}"
	fi
}

geek_apply() {
	local _cwd="$(pwd)"
	pushd "${S}" > /dev/null || die
	for i ; do
		ebegin "Applying ${i} from ${GEEK_SOURCE_REPO}"
		if [[ ${i:0:1} == / ]] ; then
			patch -f -p1 -r - -s < "${i}"
		else
			patch -f -p1 -r - -s < "${_cwd}/${i}"
		fi
		eend $?
	done
	popd > /dev/null || die
}
