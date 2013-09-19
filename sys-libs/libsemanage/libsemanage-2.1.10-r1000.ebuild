# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="python? ( <<>> )"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"

inherit eutils multilib python toolchain-funcs

SEPOL_VER="2.1.9"
SELNX_VER="2.1.13"

DESCRIPTION="SELinux kernel and policy management library"
HOMEPAGE="http://userspace.selinuxproject.org"
SRC_URI="http://userspace.selinuxproject.org/releases/20130423/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="python ruby"

RDEPEND=">=sys-libs/libsepol-${SEPOL_VER}
	>=sys-libs/libselinux-${SELNX_VER}
	dev-libs/ustr
	ruby? ( dev-lang/ruby )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	ruby? ( >=dev-lang/swig-2.0.4-r1 )
	python? ( >=dev-lang/swig-2.0.4-r1 )"

# tests are not meant to be run outside of the
# full SELinux userland repo
RESTRICT="test"

pkg_setup() {
	if use python; then
		python_pkg_setup
	fi
}

src_prepare() {
	echo "# Set this to true to save the linked policy." >> "${S}/src/semanage.conf"
	echo "# This is normally only useful for analysis" >> "${S}/src/semanage.conf"
	echo "# or debugging of policy." >> "${S}/src/semanage.conf"
	echo "save-linked=false" >> "${S}/src/semanage.conf"
	echo >> "${S}/src/semanage.conf"
	echo "# Set this to 0 to disable assertion checking." >> "${S}/src/semanage.conf"
	echo "# This should speed up building the kernel policy" >> "${S}/src/semanage.conf"
	echo "# from policy modules, but may leave you open to" >> "${S}/src/semanage.conf"
	echo "# dangerous rules which assertion checking" >> "${S}/src/semanage.conf"
	echo "# would catch." >> "${S}/src/semanage.conf"
	echo "expand-check=1" >> "${S}/src/semanage.conf"
	echo >> "${S}/src/semanage.conf"
	echo "# Modules in the module store can be compressed" >> "${S}/src/semanage.conf"
	echo "# with bzip2.  Set this to the bzip2 blocksize" >> "${S}/src/semanage.conf"
	echo "# 1-9 when compressing.  The higher the number," >> "${S}/src/semanage.conf"
	echo "# the more memory is traded off for disk space." >> "${S}/src/semanage.conf"
	echo "# Set to 0 to disable bzip2 compression." >> "${S}/src/semanage.conf"
	echo "bzip-blocksize=0" >> "${S}/src/semanage.conf"
	echo >> "${S}/src/semanage.conf"
	echo "# Reduce memory usage for bzip2 compression and" >> "${S}/src/semanage.conf"
	echo "# decompression of modules in the module store." >> "${S}/src/semanage.conf"
	echo "bzip-small=true" >> "${S}/src/semanage.conf"

	sed -e "/^gcc/s:-aux-info:-I../include &:" -i src/exception.sh

	epatch_user
}

src_compile() {
	emake AR="$(tc-getAR)" CC="$(tc-getCC)" all

	if use python; then
		python_copy_sources src
		building() {
			emake CC="$(tc-getCC)" PYINC="-I$(python_get_includedir)" PYLIBVER="python$(python_get_version)" PYPREFIX="python-$(python_get_version)" pywrap
		}
		python_execute_function -s --source-dir src building
	fi

	if use ruby; then
		emake -C src CC="$(tc-getCC)" rubywrap
	fi
}

src_install() {
	emake \
		DESTDIR="${D}" \
		LIBDIR="${D}usr/$(get_libdir)" \
		SHLIBDIR="${D}$(get_libdir)" \
		install
	dosym "../../$(get_libdir)/libsemanage.so.1" "/usr/$(get_libdir)/libsemanage.so"

	if use python; then
		installation() {
			emake \
				DESTDIR="${D}" \
				PYLIBVER="python$(python_get_version)" \
				PYPREFIX="python-$(python_get_version)" \
				LIBDIR="${D}usr/$(get_libdir)" \
				install-pywrap
		}
		python_execute_function -s --source-dir src installation
	fi

	if use ruby; then
		emake -C src \
			DESTDIR="${D}" \
			LIBDIR="${D}usr/$(get_libdir)" \
			RUBYINSTALL="${D}$(ruby -rrbconfig -e 'puts RbConfig::CONFIG["sitearchdir"]')" \
			install-rubywrap
	fi
}

pkg_postinst() {
	if use python; then
		python_mod_optimize semanage.py
	fi
}

pkg_postrm() {
	if use python; then
		python_mod_cleanup semanage.py
	fi
}
