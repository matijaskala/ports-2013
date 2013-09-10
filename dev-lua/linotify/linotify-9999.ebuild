# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit autotools eutils git-2

DESCRIPTION="inotify bindings for Lua"
HOMEPAGE="https://github.com/hoelzro/linotify"
SRC_URI=""

EGIT_REPO_URI="git://github.com/hoelzro/linotify.git https://github.com/hoelzro/linotify.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
	luajit? ( dev-lang/luajit:2 )"

src_prepare() {
	epatch_user
}

src_compile() {
	LUAPKG_CMD="lua";
	use luajit && LUAPKG_CMD="luajit";
	export LUAPKG_CMD;
	emake \
	CFLAGS="${CFLAGS} $(pkg-config ${LUAPKG_CMD} --cflags) -fPIC -O3 -Wall" \
	|| die "emake failed"
}

src_install() {
	insinto /usr/share/doc/"${P}";
	doins README.md
	emake install \
	DESTDIR="${D}" \
	INSTALL_PATH="$(pkg-config ${LUAPKG_CMD} --variable=INSTALL_CMOD)" \
	|| die "emake failed"
}
