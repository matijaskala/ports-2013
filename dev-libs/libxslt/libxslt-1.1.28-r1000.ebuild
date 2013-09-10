# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="python? ( <<>> )"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython *-pypy-*"

inherit autotools eutils python toolchain-funcs

DESCRIPTION="XSLT libraries and tools"
HOMEPAGE="http://www.xmlsoft.org/"
SRC_URI="ftp://xmlsoft.org/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="crypt debug python static-libs"

RDEPEND=">=dev-libs/libxml2-2.8.0:2
	crypt?  ( >=dev-libs/libgcrypt-1.1.42:= )
	python? ( $(python_abi_depend ">=dev-libs/libxml2-2.8.0:2[python]") )"
DEPEND="${RDEPEND}"

pkg_setup() {
	use python && python_pkg_setup
}

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=684621
	epatch "${FILESDIR}"/${PN}.m4-${PN}-1.1.26.patch

	epatch "${FILESDIR}"/${PN}-1.1.26-disable_static_modules.patch

	# Use python-config, not python2.7-config
	epatch "${FILESDIR}"/${PN}-1.1.27-python-config.patch

	# Python bindings are built/tested/installed manually.
	sed -i -e 's/$(PYTHON_SUBDIR)//' Makefile.am || die

	eautoreconf
	# If eautoreconf'd with new autoconf, then epunt_cxx is not necessary
	# and it is propably otherwise too if upstream generated with new
	# autoconf
#	epunt_cxx
}

src_configure() {
	# libgcrypt is missing pkg-config file, so fixing cross-compile
	# here. see bug 267503.
	tc-is-cross-compiler && \
		export LIBGCRYPT_CONFIG="${SYSROOT}"/usr/bin/libgcrypt-config

	econf \
		$(use_enable static-libs static) \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-html-subdir=html \
		$(use_with crypt crypto) \
		$(use_with python) \
		$(use_with debug) \
		$(use_with debug mem-debug)
}

src_compile() {
	default

	if use python; then
		python_copy_sources python
		building() {
			emake PYTHON_INCLUDES="$(python_get_includedir)" \
				PYTHON_SITE_PACKAGES="$(python_get_sitedir)" \
				PYTHON_VERSION="$(python_get_version)"
		}
		python_execute_function -s --source-dir python building
	fi
}

src_test() {
	default

	if use python; then
		testing() {
			emake test
		}
		python_execute_function -s --source-dir python testing
	fi
}

src_install() {
	default
	dodoc FEATURES

	if use python; then
		installation() {
			emake DESTDIR="${D}" \
				PYTHON_SITE_PACKAGES="$(python_get_sitedir)" \
				install
		}
		python_execute_function -s --source-dir python installation
		python_clean_installation_image

		mv "${ED}"/usr/share/doc/${PN}-python-${PV} "${ED}"/usr/share/doc/${PF}/python
	fi

	prune_libtool_files --modules
}

pkg_postinst() {
	use python && python_mod_optimize ${PN}.py
}

pkg_postrm() {
	use python && python_mod_cleanup ${PN}.py
}
