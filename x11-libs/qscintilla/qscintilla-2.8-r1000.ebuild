# Copyright owners: Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"

inherit qt4-r2

MY_P="QScintilla-gpl-${PV}"

DESCRIPTION="A Qt port of Neil Hodgson's Scintilla C++ editor class"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
# Subslot based on first component of VERSION from Qt4Qt5/qscintilla.pro
SLOT="0/11"
KEYWORDS="*"
IUSE="doc python"

DEPEND="
	|| ( dev-qt/designer:4 <dev-qt/qtgui-4.8.5:4 )
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
RDEPEND="${DEPEND}"
PDEPEND="python? ( ~dev-python/qscintilla-python-${PV} )"

S="${WORKDIR}/${MY_P}"

src_configure() {
	pushd Qt4Qt5 > /dev/null
	einfo "Configuration of qscintilla"
	eqmake4 qscintilla.pro
	popd > /dev/null

	pushd designer-Qt4Qt5 > /dev/null
	einfo "Configuration of designer plugin"
	# Avoid using of system Qsci/* headers and system libqscintilla2.so during building of libqscintillaplugin.so.
	CXXFLAGS="${CXXFLAGS}${CXXFLAGS:+ }-I../Qt4Qt5" LDFLAGS="${LDFLAGS}${LDFLAGS:+ }-L../Qt4Qt5" eqmake4 designer.pro
	popd > /dev/null
}

src_compile() {
	pushd Qt4Qt5 > /dev/null
	einfo "Building of qscintilla"
	emake
	popd > /dev/null

	pushd designer-Qt4Qt5 > /dev/null
	einfo "Building of designer plugin"
	emake
	popd > /dev/null
}

src_install() {
	pushd Qt4Qt5 > /dev/null
	einfo "Installation of qscintilla"
	emake INSTALL_ROOT="${D}" install
	popd > /dev/null

	pushd designer-Qt4Qt5 > /dev/null
	einfo "Installation of designer plugin"
	emake INSTALL_ROOT="${D}" install
	popd > /dev/null

	dodoc NEWS

	if use doc; then
		dohtml doc/html-Qt4Qt5/*
		insinto /usr/share/doc/${PF}
		doins -r doc/Scintilla
	fi
}
