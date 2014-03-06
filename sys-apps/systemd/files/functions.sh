# Copyright (c) 2007-2009 Roy Marples <roy@marples.name>
# Copyright (c) 2013 Dimitry Ishenko <dimitry.ishenko@gmail.com>
# Released under the 2-clause BSD license.

# Allow any sh script to work with einfo functions and friends
# We also provide a few helpful functions for other programs to use

# use OpenRC functions.sh, if it's present
if [ -n "${RC_LIBEXECDIR}" ]; then
	. "${RC_LIBEXECDIR}"/sh/functions.sh
else
RC_GOT_FUNCTIONS="yes"

_edent()
{
	: $(( EINFO_INDENT = ${EINFO_INDENT:-0} + ${1} ))
	[ "$EINFO_INDENT" -lt 0 ] && EINFO_INDENT=0
	[ "$EINFO_INDENT" -gt 40 ] && EINFO_INDENT=40

	EINFO_SPACE=$(printf "%${EINFO_INDENT}s" "")
	export EINFO_INDENT EINFO_SPACE
}

eindent()
{
	_edent "2"
}

eoutdent()
{
	_edent "-2"
}

yesno()
{
	[ -z "$1" ] && return 1

	case "$1" in
		[Yy][Ee][Ss]|[Tt][Rr][Uu][Ee]|[Oo][Nn]|1) return 0;;
		[Nn][Oo]|[Ff][Aa][Ll][Ss][Ee]|[Oo][Ff][Ff]|0) return 1;;
	esac

	local value=
	eval value=\$${1}
	case "$value" in
		[Yy][Ee][Ss]|[Tt][Rr][Uu][Ee]|[Oo][Nn]|1) return 0;;
		[Nn][Oo]|[Ff][Aa][Ll][Ss][Ee]|[Oo][Ff][Ff]|0) return 1;;
		*) vewarn "\$$1 is not set properly"; return 1;;
	esac
}

rc_runlevel()
{
    rc-status --runlevel
}

_sanitize_path()
{
	local IFS=":" p= path=
	for p in $PATH; do
		case "$p" in
			/lib64/rc/bin|/lib64/rc/sbin);;
			/bin|/sbin|/usr/bin|/usr/sbin);;
			/usr/bin|/usr/sbin);;
			/usr/local/bin|/usr/local/sbin);;
			*) path="$path${path:+:}$p";;
		esac
	done
	echo "$path"
}

# Allow our scripts to support zsh
if [ -n "$ZSH_VERSION" ]; then
	emulate sh
	NULLCMD=:
	alias -g '${1+"$@"}'='"$@"'
	setopt NO_GLOB_SUBST
fi

# Make a sane PATH
_PREFIX=
_PKG_PREFIX=/usr
_LOCAL_PREFIX=/usr/local
_LOCAL_PREFIX=${_LOCAL_PREFIX:-/usr/local}
_PATH=/lib64/rc/bin
case "$_PREFIX" in
	"$_PKG_PREFIX"|"$_LOCAL_PREFIX") ;;
	*) _PATH="$_PATH:$_PREFIX/bin:$_PREFIX/sbin";;
esac
_PATH="$_PATH":/bin:/sbin:/usr/bin:/usr/sbin

if [ -n "$_PKG_PREFIX" ]; then
	_PATH="$_PATH:$_PKG_PREFIX/bin:$_PKG_PREFIX/sbin"
fi
if [ -n "$_LOCAL_PREFIX" ]; then
	_PATH="$_PATH:$_LOCAL_PREFIX/bin:$_LOCAL_PREFIX/sbin"
fi
_path="$(_sanitize_path "$PATH")"
PATH="$_PATH${_path:+:}$_path" ; export PATH
unset _sanitize_path _PREFIX _PKG_PREFIX _LOCAL_PREFIX _PATH _path

for arg; do
	case "$arg" in
		--nocolor|--nocolour|-C)
			EINFO_COLOR="NO" ; export EINFO_COLOR
			;;
	esac
done

EINFO_COLOR=${EINFO_COLOR:-YES}
EINFO_QUIET=${EINFO_QUIET:-NO}
EINFO_VERBOSE=${EINFO_VERBOSE:-NO}

if yesno "${EINFO_COLOR}"; then
	GOOD=$'\e[32;01m'
	WARN=$'\e[33;01m'
	BAD=$'\e[31;01m'
	HILITE=$'\e[36;01m'
	BRACKET=$'\e[34;01m'
	NORMAL=$'\e[0m'
else
	unset GOOD WARN BAD NORMAL HILITE BRACKET
fi


einfon()
{
	yesno "${EINFO_QUIET}" || echo -ne " ${GOOD}*${NORMAL} ${EINFO_SPACE}$*"
}

einfo()
{
	einfon "$*\n"
}

ewarnn()
{
	if yesno "${EINFO_QUIET}"; then
		echo -n "$*"
	else
		echo -ne " ${WARN}*${NORMAL} ${EINFO_SPACE}$*"
	fi
}

ewarn()
{
	ewarnn "$*\n"
}

eerrorn()
{
	if yesno "${EINFO_QUIET}"; then
		echo -n "$*" >/dev/stderr
	else
		echo -ne " ${BAD}*${NORMAL} ${EINFO_SPACE}$*"
	fi
}

eerror()
{
	eerrorn "$*\n"
}

ebegin()
{
	einfo "$* ..."
}

_end()
{
	local value=${1} func=${2} msg
	shift 2

	if [ ${value} -eq 0 ]; then
		yesno "${EINFO_QUIET}" && return 0
		msg="${BRACKET}[ ${GOOD}OK${BRACKET} ]${NORMAL}"
	else
		[ -n "$*" ] && ${func} "$*"
		msg="${BRACKET}[ ${BAD}!!${BRACKET} ]${NORMAL}"
	fi

	ENDCOL=${COLUMNS:-0}
	(( ENDCOL==0 )) && ENDCOL=$(set -- `stty size 2>/dev/null` ; echo "$2")
	(( ENDCOL==0 )) && ENDCOL=80
	echo -e "\e[A\e[$(( ENDCOL-8 ))C  ${msg}"

	return ${value}
}

eend()
{
	local value="${1:-0}"
	shift

	_end "${value}" "eerror" "$*"
	return ${value}
}

ewend()
{
	local value="${1:-0}"
	shift

	_end "${value}" "ewarn" "$*"
	return ${value}
}

veinfo()
{
	yesno "${EINFO_VERBOSE}" && einfo "$@"
}

vewarn()
{
	yesno "${EINFO_VERBOSE}" && ewarn "$@"
}

veeror()
{
	yesno "${EINFO_VERBOSE}" && eerror "$@"
}

vebegin()
{
	yesno "${EINFO_VERBOSE}" && ebegin "$@"
}

veend()
{
	yesno "${EINFO_VERBOSE}" && eend "$@"
}

vewend()
{
	yesno "${EINFO_VERBOSE}" && ewend "$@"
}

fi
