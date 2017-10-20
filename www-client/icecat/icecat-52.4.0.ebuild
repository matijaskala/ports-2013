# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VIRTUALX_REQUIRED="pgo"
WANT_AUTOCONF="2.1"
MOZ_ESR=1

# This list can be updated with scripts/get_langs.sh from the mozilla overlay
MOZ_LANGS=( ach af an ar as ast az bg bn-BD bn-IN br bs ca cak cs cy da de dsb
el en en-GB en-US en-ZA eo es-AR es-CL es-ES es-MX et eu fa ff fi fr fy-NL ga-IE
gd gl gn gu-IN he hi-IN hr hsb hu hy-AM id is it ja ka kab kk km kn ko lij lt lv
mai mk ml mr ms nb-NO nl nn-NO or pa-IN pl pt-BR pt-PT rm ro ru si sk sl son sq
sr sv-SE ta te th tr uk uz vi xh zh-CN zh-TW )

# Convert the ebuild version to the upstream mozilla version, used by mozlinguas
MOZ_PV="${PV/_alpha/a}" # Handle alpha for SRC_URI
MOZ_PV="${MOZ_PV/_beta/b}" # Handle beta for SRC_URI
MOZ_PV="${MOZ_PV/_rc/rc}" # Handle rc for SRC_URI

if [[ ${MOZ_ESR} == 1 ]]; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
fi

# Patch version
PATCH="firefox-52.4-patches-02"
MOZ_HTTP_URI="https://archive.mozilla.org/pub/firefox/releases"

MOZCONFIG_OPTIONAL_GTK3=1
MOZCONFIG_OPTIONAL_WIFI=1

MOZ_PN="firefox"
MOZ_P="firefox-${MOZ_PV}"
MOZEXTENSION_TARGET=browser/extensions

inherit check-reqs flag-o-matic toolchain-funcs eutils gnome2-utils mozconfig-v6.52 pax-utils xdg-utils autotools virtualx mozlinguas-v2 geek

DESCRIPTION="IceCat Web Browser"
HOMEPAGE="https://www.gnu.org/software/gnuzilla"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 x86 amd64-linux x86-linux"

SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1 GPL-3 LGPL-3"
IUSE="eme-free +gmp-autoupdate hardened hwaccel jack pgo rust selinux test"

GNUZILLA_REPO_URI="git://git.sv.gnu.org/gnuzilla.git"

PATCH_URIS=( https://dev.gentoo.org/~{anarchy,axs,polynomial-c}/mozilla/patchsets/${PATCH}.tar.xz )
SRC_URI="${SRC_URI}
	${MOZ_HTTP_URI}/${MOZ_PV}/source/firefox-${MOZ_PV}.source.tar.xz
	${PATCH_URIS[@]}"

ASM_DEPEND=">=dev-lang/yasm-1.1"

RDEPEND="
	jack? ( virtual/jack )
	>=dev-libs/nss-3.28.3
	>=dev-libs/nspr-4.13.1
	selinux? ( sec-policy/selinux-mozilla )"

DEPEND="${RDEPEND}
	pgo? ( >=sys-devel/gcc-4.5 )
	rust? ( virtual/rust )
	amd64? ( ${ASM_DEPEND} virtual/opengl )
	x86? ( ${ASM_DEPEND} virtual/opengl )"

S="${WORKDIR}/firefox-${MOZ_PV}"

QA_PRESTRIPPED="usr/lib*/${PN}/firefox"

BUILD_OBJ_DIR="${S}/ff"

# allow GMP_PLUGIN_LIST to be set in an eclass or
# overridden in the enviromnent (advanced hackers only)
if [[ -z $GMP_PLUGIN_LIST ]]; then
	GMP_PLUGIN_LIST=( gmp-gmpopenh264 gmp-widevinecdm )
fi

pkg_setup() {
	moz_pkgsetup

	# Avoid PGO profiling problems due to enviroment leakage
	# These should *always* be cleaned up anyway
	unset DBUS_SESSION_BUS_ADDRESS \
		DISPLAY \
		ORBIT_SOCKETDIR \
		SESSION_MANAGER \
		XDG_SESSION_COOKIE \
		XAUTHORITY

	if use pgo; then
		einfo
		ewarn "You will do a double build for profile guided optimization."
		ewarn "This will result in your build taking at least twice as long as before."
	fi

	if use rust; then
		einfo
		ewarn "This is very experimental, should only be used by those developing firefox."
	fi
}

pkg_pretend() {
	# Ensure we have enough disk space to compile
	if use pgo || use debug || use test ; then
		CHECKREQS_DISK_BUILD="8G"
	else
		CHECKREQS_DISK_BUILD="4G"
	fi
	check-reqs_pkg_setup
}

src_unpack() {
	unpack ${A}

	# Unpack language packs
	mozlinguas_src_unpack

	geek_prepare_storedir
	geek_fetch gnuzilla
}

src_prepare() {
	# Apply our patches
	eapply "${WORKDIR}/firefox"
	eapply "${GEEK_STORE_DIR}/gnuzilla/data/patches"/*
	eapply "${FILESDIR}"/reorder-addon-sdk-moz.build.patch
	eapply "${FILESDIR}"/52-unity-menubar.patch

	# Enable gnomebreakpad
	if use debug ; then
		sed -i -e "s:GNOME_DISABLE_CRASH_DIALOG=1:GNOME_DISABLE_CRASH_DIALOG=0:g" \
			"${S}"/build/unix/run-mozilla.sh || die "sed failed!"
	fi

	# Drop -Wl,--as-needed related manipulation for ia64 as it causes ld sefgaults, bug #582432
	if use ia64 ; then
		sed -i \
		-e '/^OS_LIBS += no_as_needed/d' \
		-e '/^OS_LIBS += as_needed/d' \
		"${S}"/widget/gtk/mozgtk/gtk2/moz.build \
		"${S}"/widget/gtk/mozgtk/gtk3/moz.build \
		|| die "sed failed to drop --as-needed for ia64"
	fi

	# Ensure that our plugins dir is enabled as default
	sed -i -e "s:/usr/lib/mozilla/plugins:/usr/lib/nsbrowser/plugins:" \
		"${S}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 32bit!"
	sed -i -e "s:/usr/lib64/mozilla/plugins:/usr/lib64/nsbrowser/plugins:" \
		"${S}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 64bit!"

	# Fix sandbox violations during make clean, bug 372817
	sed -e "s:\(/no-such-file\):${T}\1:g" \
		-i "${S}"/config/rules.mk \
		-i "${S}"/nsprpub/configure{.in,} \
		|| die

	# Don't exit with error when some libs are missing which we have in
	# system.
	sed '/^MOZ_PKG_FATAL_WARNINGS/s@= 1@= 0@' \
		-i "${S}"/browser/installer/Makefile.in || die

	# Don't error out when there's no files to be removed:
	sed 's@\(xargs rm\)$@\1 -f@' \
		-i "${S}"/toolkit/mozapps/installer/packager.mk || die

	# Keep codebase the same even if not using official branding
	sed '/^MOZ_DEV_EDITION=1/d' \
		-i "${S}"/browser/branding/aurora/configure.sh || die

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	einfo "Converting into IceCat ..."
	sed '/mozilla\.org\/legal/d' -i "${S}"/services/healthreport/healthreport-prefs.js
	sed "s|^\(pref(\"datareporting\.healthreport\.infoURL.*\", \"\)https://.*\(\");\)$|\1${HOMEPAGE}\2|" -i "${S}"/{services/healthreport,mobile/android/chrome/content}/healthreport-prefs.js
	sed "s|https://www\.mozilla\.org/legal/privacy/|${HOMEPAGE}/|" -i "${S}"/browser/app/profile/firefox.js "${S}"/toolkit/content/aboutRights.xhtml
	for i in "${GEEK_STORE_DIR}"/gnuzilla/data/searchplugins/* ; do
		cp "${i}" "${S}"/browser/locales/en-US/searchplugins
		echo "$(basename "${i%.xml}")" >> "${S}"/browser/locales/en-US/searchplugins/list.txt
		cp "${i}" "${S}"/mobile/locales/en-US/searchplugins
		echo "$(basename "${i%.xml}")" >> "${S}"/mobile/locales/en-US/searchplugins/list.txt
	done
	mv "${S}"/browser/locales/en-US/searchplugins/{duckduckgo,ddg}.xml || die
	for i in base/content/newtab/newTab.css themes/linux/newtab/newTab.css themes/windows/newtab/newTab.css themes/osx/newtab/newTab.css ; do
		echo '#newtab-customize-button, #newtab-intro-what{display:none}' >> "${S}/browser/${i}"
	done
	sed '/Promo2.iOSBefore/,/mobilePromo2.iOSLink/d' -i "${S}"/browser/components/preferences/in-content/sync.xul
	sed 's|www.mozilla.org/firefox/android.*sync-preferences|f-droid.org/repository/browse/?fdid=org.gnu.icecat|' -i "${S}"/browser/components/preferences/in-content/sync.xul
	rm -rf "${S}"/{browser,mobile/android}/branding/*/
	cp "${FILESDIR}"/identity-icons-brand.svg "${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat/content
	cp -a "${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat "${S}"/browser/branding/official
	cp -a "${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat "${S}"/browser/branding/unofficial
	cp -a "${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat "${S}"/browser/branding/nightly
	echo "  content/branding/identity-icons-brand.svg" >> "${S}"/browser/branding/official/content/jar.mn
	echo "  content/branding/identity-icons-brand.svg" >> "${S}"/browser/branding/unofficial/content/jar.mn
	echo "  content/branding/identity-icons-brand.svg" >> "${S}"/browser/branding/nightly/content/jar.mn
	cp -a "${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecatmobile "${S}"/mobile/android/branding/official
	cp -a "${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecatmobile "${S}"/mobile/android/branding/unofficial
	cp -a "${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecatmobile "${S}"/mobile/android/branding/nightly
	rm -rf "${S}"/browser/base/content/abouthome
	cp -a "${GEEK_STORE_DIR}"/gnuzilla/data/abouthome "${S}"/browser/base/content
	sed '/mozilla.*png/d' -i "${S}"/browser/base/jar.mn
	sed '/abouthome/s/*/ /' -i "${S}"/browser/base/jar.mn
	cp "${GEEK_STORE_DIR}"/gnuzilla/data/bookmarks.html.in "${S}"/browser/locales/generic/profile
	for i in community.end3 community.exp.end community.start2 community.mozillaLink community.middle2 community.creditsLink \
	community.end2 contribute.start contribute.getInvolvedLink contribute.end channel.description.start channel.description.end ; do
		find "${WORKDIR}/${MOZ_P}"*/* -name aboutDialog.dtd -exec sed -i "s|\(ENTITY ${i}\).*|\1 \"\">|" {} +
	done
	for i in rights.intro-point3-unbranded rights.intro-point4a-unbranded rights.intro-point4b-unbranded rights.intro-point4c-unbranded ; do
		find "${WORKDIR}/${MOZ_P}"*/* -name aboutRights.dtd -exec sed -i "s|\(ENTITY ${i}\).*|\1 \"\">|" {} +
	done
	find -name brand.dtd -exec sed -i 's/\(trademarkInfo.part1\s*"\).*\(">\)/\1\2/' {} +
	sed -i '/helpus\.start/d' "${S}"/browser/base/content/aboutDialog.xul
	cp "${GEEK_STORE_DIR}"/gnuzilla/data/aboutRights.xhtml "${S}"/toolkit/content/aboutRights.xhtml
	cp "${GEEK_STORE_DIR}"/gnuzilla/data/aboutRights.xhtml "${S}"/toolkit/content/aboutRights-unbranded.xhtml
	sed -i 's|<a href="http://www.mozilla.org/">Mozilla Project</a>|<a href="http://www.gnu.org/">GNU Project</a>|' browser/base/content/overrides/app-license.html
	cp "${GEEK_STORE_DIR}"/gnuzilla/data/branding/sync.png "${S}"/browser/themes/shared/fxa/logo.png
	find "${WORKDIR}/${MOZ_P}"*/ -type d -name firefox -exec rename firefox icecat {} +
	find "${WORKDIR}/${MOZ_P}"*/ -type d -name firefox-ui -exec rename firefox icecat {} +
	find "${WORKDIR}/${MOZ_P}"*/ -type d -name \*firefox\* -exec rename firefox icecat {} +
	find "${WORKDIR}/${MOZ_P}"*/ -type f -name \*firefox\* -exec rename firefox icecat {} +
	find "${WORKDIR}/${MOZ_P}"*/ -type f -name \*Firefox\* -exec rename Firefox IceCat {} +
	find "${WORKDIR}/${MOZ_P}"*/ -type d -name \*fennec\* -exec rename fennec icecatmobile {} +
	find "${WORKDIR}/${MOZ_P}"*/ -type f -name \*fennec\* -exec rename fennec icecatmobile {} +
	find "${WORKDIR}/${MOZ_P}"*/ -type f -name \*Fennec\* -exec rename Fennec IceCatMobile {} +
	find "${WORKDIR}/${MOZ_P}"*/ -type f -name run-mozilla.sh -execdir mv {} run-icecat.sh \;
	find "${WORKDIR}/${MOZ_P}"*/ -type f -not -iregex '.*changelog.*' -not -iregex '.*copyright.*' -execdir sed --follow-symlinks -i "
		s|marketplace\.firefox\.com|f-droid.org/repository/browse|;
		s|org\.mozilla\.firefox|org.gnu.icecat|;
		s|Adobe Flash|Flash|;
		s|addons\.mozilla\.org.*/mobile|directory.fsf.org/wiki/GNU_IceCat|;
		s|addons\.mozilla\.org.*/android|directory.fsf.org/wiki/GNU_IceCat|;
		s|support\.mozilla\.org.*/mobile|libreplanet.org/wiki/Group:IceCat/icecat-help|;
		s|run-mozilla\.sh|run-icecat.sh|;
		s|mozilla-bin|icecat-bin|;
		s|Firefox Marketplace|F-droid free software repository|;
		s|https*://www\.mozilla\.com/plugincheck|${HOMEPAGE}/addons.html|;
		s|ww*3*\.mozilla\.com/plugincheck|${HOMEPAGE}/addons.html|;
		s|mozilla\.com/plugincheck|${HOMEPAGE}/addons.html|;
		s|\"https://www\.mozilla\..../legay/privacy.*\"|\"${HOMEPAGE}\"|;
		s|https://www\.mozilla\..../legay/privacy|${HOMEPAGE}|;

		s|Mozilla Firefox|GNU IceCat|;
		s|Mozilla Firefox|GNU IceCat|;
		s|firefox|icecat|;
		s|firefox|icecat|;
		s|firefox|icecat|;
		s|firefox|icecat|;
		s|firefox|icecat|;
		s|fennec|icecatmobile|;
		s|fennec|icecatmobile|;
		s|Firefox|IceCat|;
		s|Firefox|IceCat|;
		s|Firefox|IceCat|;
		s|Firefox|IceCat|;
		s|Firefox|IceCat|;
		s|Fennec|IceCatMobile|;
		s|Fennec|IceCatMobile|;
		s|FIREFOX|ICECAT|;
		s|FIREFOX|ICECAT|;
		s|FENNEC|ICECATMOBILE|;
		s|FENNEC|ICECATMOBILE|;
		s| Mozilla | GNU |;
		s| Mozilla | GNU |;

		s|GNU Public|Mozilla Public|;
		s|GNU Foundation|Mozilla Foundation|;
		s|GNU Corporation|Mozilla Corporation|;
		s|icecat.com|firefox.com|;
		s|IceCat-Spdy|Firefox-Spdy|;
		s|icecat-accounts|firefox-accounts|;
		s|IceCatAccountsCommand|FirefoxAccountsCommand|;
		s|https://www.mozilla.org/icecat/?utm_source=synceol|https://www.mozilla.org/firefox/?utm_source=synceol|;
	" "{}" ";"
	find -name region.properties -exec sed -i 's|https://www\.mibbit\..*$||' -i {} +
	sed -i s/mozilla-esr/gnu-esr/ browser/confvars.sh
	cat "${GEEK_STORE_DIR}"/gnuzilla/data/settings.js >> "${S}"/browser/app/profile/icecat.js
	cat "${GEEK_STORE_DIR}"/gnuzilla/data/settings.js >> "${S}"/mobile/android/app/mobile.js

        favicon="${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat/icecat.ico
        jpglogo="${GEEK_STORE_DIR}"/gnuzilla/data/../artwork/icecat.jpg
        ff256="${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat/default256.png
        ff128="${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat/mozicon128.png
        ff64="${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat/content/icon64.png
        ff48="${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat/default48.png
        ff32="${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat/default32.png
        ff24="${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat/default24.png
        ff22="${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat/default22.png
        ff16="${GEEK_STORE_DIR}"/gnuzilla/data/branding/icecat/default16.png
        gf300="${GEEK_STORE_DIR}"/gnuzilla/data/android-images/resources/drawable-xhdpi/icon_home_empty_icecat.png
        gf225="${GEEK_STORE_DIR}"/gnuzilla/data/android-images/resources/drawable-hdpi/icon_home_empty_icecat.png
        gf150="${GEEK_STORE_DIR}"/gnuzilla/data/android-images/resources/drawable-mdpi/icon_home_empty_icecat.png
        gf32="${GEEK_STORE_DIR}"/gnuzilla/data/android-images/resources/drawable-xhdpi/ic_status_logo.png
        gf24="${GEEK_STORE_DIR}"/gnuzilla/data/android-images/resources/drawable-hdpi/ic_status_logo.png
        gf16="${GEEK_STORE_DIR}"/gnuzilla/data/android-images/resources/drawable-mdpi/ic_status_logo.png
        wf24="${GEEK_STORE_DIR}"/gnuzilla/data/android-images/resources/drawable-mdpi-v11/ic_status_logo.png
        wf48="${GEEK_STORE_DIR}"/gnuzilla/data/android-images/resources/drawable-xhdpi-v11/ic_status_logo.png
        wf36="${GEEK_STORE_DIR}"/gnuzilla/data/android-images/resources/drawable-hdpi-v11/ic_status_logo.png
        ma50="${GEEK_STORE_DIR}"/gnuzilla/data/android-images/core/marketplace-logo.png
        ma128="${GEEK_STORE_DIR}"/gnuzilla/data/android-images/resources/drawable-mdpi/marketplace.png

        cp "${ff64}"  "${S}"/devtools/client/framework/dev-edition-promo/dev-edition-logo.png
        cp "${ff128}" "${S}"/mobile/android/base/resources/raw/bookmarkdefaults_favicon_support.png
        cp "${favicon}" "${S}"/addon-sdk/source/examples/toolbar-api/data/favicon.ico
        cp "${gf32}" "${S}"/browser/themes/shared/icon.png
        cp "${gf150}" "${S}"/mobile/android/base/resources/drawable-hdpi/icon_search_empty_icecat.png
        cp "${gf150}" "${S}"/mobile/android/base/resources/drawable-xhdpi/icon_search_empty_icecat.png
        cp "${gf150}" "${S}"/mobile/android/base/resources/drawable-xxhdpi/icon_search_empty_icecat.png
        cp "${gf32}" "${S}"/browser/themes/shared/theme-switcher-icon.png
        cp "${gf32}" "${S}"/browser/themes/shared/heme-switcher-icon@2x.png
        cp "${gf32}" "${S}"/browser/base/content/aboutaccounts/images/fox.png

        cp "${ff16}" "${S}"/dom/canvas/test/crossorigin/image.png
        cp "${ff16}" "${S}"/image/test/unit/image1.png
        cp "${jpglogo}"  "${S}"/image/test/unit/image1png16x16.jpg
        cp "${jpglogo}"  "${S}"/image/test/unit/image1png64x64.jpg
        cp "${ff16}" "${S}"/image/test/unit/image2jpg16x16.png
        cp "${ff16}" "${S}"/image/test/unit/image2jpg16x16-win.png
        cp "${ff32}" "${S}"/image/test/unit/image2jpg32x32.png
        cp "${ff32}" "${S}"/image/test/unit/image2jpg32x32-win.png
        cp "${ff16}" "${S}"/dom/canvas/test/crossorigin/image-allow-credentials.png
        cp "${ff16}" "${S}"/dom/html/test/image-allow-credentials.png
        cp "${ff16}" "${S}"/dom/canvas/test/crossorigin/image-allow-star.png
        cp "${ff32}" "${S}"/toolkit/webapps/tests/data/icon.png
        cp "${ff16}" "${S}"/toolkit/components/places/tests/favicons/expected-favicon-big32.jpg.png
        cp "${ff16}" "${S}"/toolkit/components/places/tests/favicons/expected-favicon-big64.png.png
        cp "${jpglogo}"  "${S}"/toolkit/components/places/tests/favicons/favicon-big32.jpg
        cp "${ff64}" "${S}"/toolkit/components/places/tests/favicons/favicon-big64.png
        cp "${favicon}" "${S}"/image/test/unit/image4gif16x16bmp24bpp.ico
        cp "${favicon}" "${S}"/image/test/unit/image4gif16x16bmp32bpp.ico
        cp "${favicon}" "${S}"/image/test/unit/image4gif32x32bmp24bpp.ico
        cp "${favicon}" "${S}"/image/test/unit/image4gif32x32bmp32bpp.ico
        cp "${jpglogo}" "${S}"/image/test/unit/image1png16x16.jpg
        cp "${jpglogo}" "${S}"/image/test/unit/image2.jpg
        cp "${jpglogo}" "${S}"/image/test/unit/image2jpg16x16cropped.jpg
        cp "${jpglogo}" "${S}"/image/test/unit/image2jpg16x16cropped2.jpg
        cp "${jpglogo}" "${S}"/image/test/unit/image2jpg16x32cropped3.jpg
        cp "${jpglogo}" "${S}"/image/test/unit/image2jpg16x32scaled.jpg
        cp "${jpglogo}" "${S}"/image/test/unit/image2jpg32x16cropped4.jpg
        cp "${jpglogo}" "${S}"/image/test/unit/image2jpg32x16scaled.jpg
        cp "${jpglogo}" "${S}"/image/test/unit/image2jpg32x32.jpg
        cp "${ff32}" "${S}"/image/test/unit/image2jpg32x32.png
        cp "${ff32}" "${S}"/image/test/unit/image2jpg32x32-win.png

	for x in "${mozlinguas[@]}" ; do
		for i in "${WORKDIR}/${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}"/browser/chrome/${x}/locale/branding/brand.{dtd,properties} ; do
			sed -i 's/\(trademarkInfo.part1\s*"\).*\(">\)/\1\2/' "${i}" || die
		done
	done

	# Autotools configure is now called old-configure.in
	# This works because there is still a configure.in that happens to be for the
	# shell wrapper configure script
	eautoreconf old-configure.in

	# Must run autoconf in js/src
	cd "${S}"/js/src || die
	eautoconf old-configure.in

	# Need to update jemalloc's configure
	cd "${S}"/memory/jemalloc/src || die
	WANT_AUTOCONF= eautoconf
}

src_configure() {
	MEXTENSIONS="default"
	# Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
	# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
	# get your own set of keys.
	_google_api_key=AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init
	mozconfig_config

	# enable JACK, bug 600002
	mozconfig_use_enable jack

	use eme-free && mozconfig_annotate '+eme-free' --disable-eme

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	# Add full relro support for hardened
	use hardened && append-ldflags "-Wl,-z,relro,-z,now"

	# Setup api key for location services
	echo -n "${_google_api_key}" > "${S}"/google-api-key
	mozconfig_annotate '' --with-google-api-keyfile="${S}/google-api-key"

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"

	mozconfig_use_enable rust

	# Allow for a proper pgo build
	if use pgo; then
		echo "mk_add_options PROFILE_GEN_SCRIPT='EXTRA_TEST_ARGS=10 \$(MAKE) -C \$(MOZ_OBJDIR) pgo-profile-run'" >> "${S}"/.mozconfig
	fi

	echo "mk_add_options MOZ_OBJDIR=${BUILD_OBJ_DIR}" >> "${S}"/.mozconfig
	echo "mk_add_options XARGS=/usr/bin/xargs" >> "${S}"/.mozconfig

	# Finalize and report settings
	mozconfig_final

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	# workaround for funky/broken upstream configure...
	SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
	emake -f client.mk configure
}

src_compile() {
	if use pgo; then
		addpredict /root
		addpredict /etc/gconf
		# Reset and cleanup environment variables used by GNOME/XDG
		gnome2_environment_reset

		# Firefox tries to use dri stuff when it's run, see bug 380283
		shopt -s nullglob
		cards=$(echo -n /dev/dri/card* | sed 's/ /:/g')
		if test -z "${cards}"; then
			cards=$(echo -n /dev/ati/card* /dev/nvidiactl* | sed 's/ /:/g')
			if test -n "${cards}"; then
				# Binary drivers seem to cause access violations anyway, so
				# let's use indirect rendering so that the device files aren't
				# touched at all. See bug 394715.
				export LIBGL_ALWAYS_INDIRECT=1
			fi
		fi
		shopt -u nullglob
		[[ -n ${cards} ]] && addpredict "${cards}"

		MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
		virtx emake -f client.mk profiledbuild || die "virtx emake failed"
	else
		MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
		emake -f client.mk realbuild
	fi

}

src_install() {
	cd "${BUILD_OBJ_DIR}" || die

	# Pax mark xpcshell for hardened support, only used for startupcache creation.
	pax-mark m "${BUILD_OBJ_DIR}"/dist/bin/xpcshell

	# Add our default prefs for firefox
	cp "${FILESDIR}"/gentoo-default-prefs.js-1 \
		"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
		|| die

	mozconfig_install_prefs \
		"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js"

	# Augment this with hwaccel prefs
	if use hwaccel ; then
		cat "${FILESDIR}"/gentoo-hwaccel-prefs.js-1 >> \
		"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
		|| die
	fi

	echo "pref(\"extensions.autoDisableScopes\", 3);" >> \
		"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
		|| die

		echo "pref(\"plugin.load_flash_only\", false);" >> \
			"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
			|| die

	local plugin
	use gmp-autoupdate || use eme-free || for plugin in "${GMP_PLUGIN_LIST[@]}" ; do
		echo "pref(\"media.${plugin}.autoupdate\", false);" >> \
			"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
			|| die
	done

	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
	emake DESTDIR="${D}" install

	# Install language packs
	mozlinguas_src_install

	# Install extensions
	for x in "${GEEK_STORE_DIR}"/gnuzilla/data/extensions/* ; do
		xpi_install "${x}"
	done

		# Override preferences to set the MOZ_DEV_EDITION defaults, since we
		# don't define MOZ_DEV_EDITION to avoid profile debaucles.
		# (source: browser/app/profile/firefox.js)
		cat >>"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" <<PROFILE_EOF
pref("app.feedback.baseURL", "https://input.mozilla.org/%LOCALE%/feedback/firefoxdev/%VERSION%/");
sticky_pref("lightweightThemes.selectedThemeID", "firefox-devedition@mozilla.org");
sticky_pref("browser.devedition.theme.enabled", true);
sticky_pref("devtools.theme", "dark");
PROFILE_EOF

		sizes="16 22 24 32 48 256"
		icon_path="${S}/browser/branding/official"
		icon="${PN}"
		name="GNU IceCat"

	# Install icons and .desktop for menu entry
	for size in ${sizes}; do
		insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
		newins "${icon_path}/default${size}.png" "${icon}.png"
	done
	# The 128x128 icon has a different name
	insinto "/usr/share/icons/hicolor/128x128/apps"
	newins "${icon_path}/mozicon128.png" "${icon}.png"
	# Install a 48x48 icon into /usr/share/pixmaps for legacy DEs
	newicon "${icon_path}/content/icon48.png" "${icon}.png"
	newmenu "${FILESDIR}/icon/${PN}.desktop" "${PN}.desktop"
	sed -i -e "s:@NAME@:${name}:" -e "s:@ICON@:${icon}:" \
		"${ED}/usr/share/applications/${PN}.desktop" || die

	# Add StartupNotify=true bug 237317
	if use startup-notification ; then
		echo "StartupNotify=true"\
			 >> "${ED}/usr/share/applications/${PN}.desktop" \
			|| die
	fi

	# Required in order to use plugins and even run firefox on hardened.
	pax-mark m "${ED}"${MOZILLA_FIVE_HOME}/{firefox,firefox-bin,plugin-container}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	# Update mimedb for the new .desktop file
	xdg_desktop_database_update
	gnome2_icon_cache_update

	if ! use gmp-autoupdate && ! use eme-free ; then
		elog "USE='-gmp-autoupdate' has disabled the following plugins from updating or"
		elog "installing into new profiles:"
		local plugin
		for plugin in "${GMP_PLUGIN_LIST[@]}"; do elog "\t ${plugin}" ; done
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
