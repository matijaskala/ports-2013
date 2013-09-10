# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit bash-completion autotools eutils

DESCRIPTION="OpenVZ Containers control utility"
HOMEPAGE="http://openvz.org/"
GITHUB_USER="funtoo"
GITHUB_TAG="${P}-funtoo"
SRC_URI="https://github.com/${GITHUB_USER}/${PN}/tarball/${GITHUB_TAG} -> ${GITHUB_TAG}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="bash-completion"

RDEPEND="
	net-firewall/iptables
	sys-apps/ed
	sys-apps/iproute2
	sys-fs/vzquota
	>=sys-apps/openrc-0.6.5-r1"
DEPEND=""

src_unpack() {
	unpack ${A}
	mv funtoo-vzctl-??????? vzctl-${PV} || die
}

src_prepare() {
	# Set default OSTEMPLATE on gentoo
	sed -e 's:=redhat-:=funtoo-:' -i etc/dists/default || die
	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		--enable-udev \
		$(use_enable bash-completion bashcomp) \
		--enable-logrotate
}

src_install() {
	make DESTDIR="${D}" install install-gentoo || die "make install failed"

	# install the bash-completion script into the right location
	rm -rf "${ED}"/etc/bash_completion.d
	dobashcompletion etc/bash_completion.d/vzctl.sh vzctl

	# We need to keep some dirs
	keepdir /vz/{dump,lock,root,private,template/cache}
	keepdir /etc/vz/names /var/lib/vzctl/veip

	# enable bridge auto-add for veth devices:
	insinto /etc/vz
	doins ${FILESDIR}/vznet.conf

	# install our tweaked /etc/init.d/vz
	exeinto /etc/init.d
	newexe ${FILESDIR}/${PV}/vz.initd vz
}

pkg_postinst() {
	bash-completion_pkg_postinst
	local conf_without_OSTEMPLATE
	for file in \
		$(find "${EROOT}/etc/vz/conf/" \( -name *.conf -a \! -name 0.conf \)); do
		if ! grep '^OSTEMPLATE' $file > /dev/null; then
			conf_without_OSTEMPLATE+=" $file"
		fi
	done

	if [[ -n ${conf_without_OSTEMPLATE} ]]; then
		ewarn
		ewarn "OSTEMPLATE default was changed from Red Hat to Funtoo."
		ewarn "This means that any VEID.conf files without explicit or correct"
		ewarn "OSTEMPLATE set will use Funtoo scripts instead of Red Hat."
		ewarn "Please check the following configs:"
		for file in ${conf_without_OSTEMPLATE}; do
			ewarn "${file}"
		done
		ewarn
	fi
	ewarn "Starting with 3.0.25 there is new vzeventd service to reboot CTs."
	ewarn "Please, drop /usr/share/vzctl/scripts/vpsnetclean and"
	ewarn "/usr/share/vzctl/scripts/vpsreboot from crontab and use"
	ewarn "/etc/init.d/vzeventd."

	# TODO - when Funtoo has an OpenRC with "condrestart", add an 
	# /etc/init.d/vzeventd condrestart when ROOT = "/" to ensure that the
	# latest vzeventd is running. Not doing this can result in containers
	# not rebooting correctly after upgrade or other issues.

}
