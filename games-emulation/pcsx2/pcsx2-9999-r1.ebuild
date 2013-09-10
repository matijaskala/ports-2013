# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WX_GTK_VER="2.8"

# no need for amd64 as we will use precompiled wxGTK.
if use x86; then
	inherit wxwidgets
fi

inherit games cmake-utils subversion

DESCRIPTION="A PlayStation 2 emulator"
HOMEPAGE="http://www.pcsx2.net"
ESVN_REPO_URI="http://pcsx2.googlecode.com/svn/trunk"
ESVN_PROJECT="pcsx2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"
if use amd64; then
	ABI="x86"
fi
if use debug; then
	CMAKE_BUILD_TYPE="Debug"
else
	CMAKE_BUILD_TYPE="Release"
fi

DEPEND="dev-cpp/sparsehash
	x86? (
		app-arch/bzip2
		sys-libs/zlib
		media-libs/alsa-lib
		media-libs/glew
		media-libs/libsdl
		media-libs/portaudio
		media-gfx/nvidia-cg-toolkit
		virtual/jpeg
		virtual/opengl
		x11-libs/gtk+:2
		x11-libs/libICE
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/wxGTK[X]
	)
	amd64? ( media-gfx/nvidia-cg-toolkit[multilib]
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-gtklibs
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-wxGTK
		x11-libs/wxGTK[X]
	)"
RDEPEND="${DEPEND}"

src_configure() {
	wxgtk_config=""
	cg_config=""
	if use amd64; then
		# tell cmake to use 32 bit library
		mylibpath="/usr/lib32"
		wxgtk_config="-DwxWidgets_CONFIG_EXECUTABLE=/usr/bin/wx-config-32"
		cg_config="-DCG_LIBRARY=/opt/nvidia-cg-toolkit/lib32/libCg.so
					-DCG_GL_LIBRARY=/opt/nvidia-cg-toolkit/lib32/libCgGL.so"
	else
		mylibpath="/usr/lib"
	fi

	mycmakeargs="
		-DPACKAGE_MODE=1
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_LIBRARY_PATH=${mylibpath}
		${wxgtk_config}
		${cg_config}
		"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install DESTDIR=${D}

	# move binary files to correct directory
	mkdir -p ${D}/usr/games/bin
	mv ${D}/usr/bin/* ${D}/usr/games/bin || die

	prepgamesdirs
}

pkg_postinst() {
	if use amd64; then
		einfo "We currently use 64bit dev-cpp/sparsehash for compiling pcsx2"
		einfo "since sparsehash installation contains only header files."
		einfo "If you encounter any problems with that, try"
		einfo ""
		einfo "    ABI=\"x86\" emerge sparsehash"
		einfo ""
		einfo "and remerge pcsx2 before reporting bugs."
	fi
}
