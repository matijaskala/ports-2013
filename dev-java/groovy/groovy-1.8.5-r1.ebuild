# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/groovy/groovy-1.8.5-r1.ebuild,v 1.1 2013/10/23 18:49:46 tomwij Exp $

# Groovy's build system is Ant based, but they use Maven for fetching the dependencies.
# We just have to remove the fetch dependencies target, and then we can use Ant for this ebuild.

# We currently do not build the embeddable jar (which is created using JarJar).
# We could provide that via an USE flag.
# We also don't use automatic build rewriting as there seems to be already some level of support
# in the upstream build system

# TODO: Install all 3 documentation packages. Currently only the Groovy GDK documentation is installed
# as our java-pkg_dojavadoc function does not support multiple Javadoc installations.

EAPI="3"
WANT_ANT_TASKS="ant-antlr"
JAVA_PKG_IUSE="doc source"

inherit base versionator java-pkg-2 java-ant-2

MY_PV=${PV/_rc/-RC-}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Groovy is a high-level dynamic language for the JVM"
HOMEPAGE="http://groovy.codehaus.org/"

SRC_URI="http://dist.groovy.codehaus.org/distributions/${PN}-src-${PV}.zip"
LICENSE="codehaus-groovy"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"
RESTRICT="test"

CDEPEND=">=dev-java/asm-3.2:3
	>=dev-java/ant-core-1.8.0:0
	>=dev-java/junit-4.6:4
	dev-java/antlr:0
	dev-java/xstream:0
	dev-java/jline:0
	dev-java/commons-cli:1
	dev-java/jansi:0
	java-virtuals/servlet-api:2.4
	>=dev-java/bsf-2.4:2.3
	java-virtuals/jmx:0"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	dev-java/ant-ivy:2
	doc? (
		dev-java/qdox:1.12
		dev-java/commons-logging:0
	)
	test? (
		dev-java/jmock:1.0
		dev-java/xmlunit:1
		dev-db/hsqldb:0
		dev-java/commons-logging:0
		dev-java/ant-junit:0
		dev-java/ant-trax:0
	)
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${PN}-1.8-build-pref-locking-fix.patch" )

JAVA_PKG_BSFIX=""

src_prepare() {
	base_src_prepare
	sed -i -e 's/fullQualifiedName/fullyQualifiedName/g' \
		src/tools/org/codehaus/groovy/tools/DocGenerator.groovy

	rm -rf bootstrap
	# security directory is needed for tests, but they currently don't pass
	#rm -rf security
	mkdir -p target/lib && cd target/lib
	mkdir compile && mkdir runtime && mkdir tools
	cd compile

	java-pkg_jar-from commons-cli-1,ant-core,antlr,asm-3,xstream,jansi
	java-pkg_jar-from jline,junit,servlet-api-2.4,bsf-2.3
	java-pkg_jar-from --virtual jmx
	java-pkg_jar-from --build-only ant-ivy:2
	use doc && java-pkg_jar-from --build-only qdox-1.12,ant-antlr,commons-logging
}

src_compile() {
	eant -DskipTests="true" -DruntimeLibDirectory="target/lib/compile" \
		-DtoolsLibDirectory="target/lib/compile" -DskipFetch="true" -DskipEmbeddable="true"

	use doc && ANT_TASKS="ant-antlr" ANT_OPTS="-Duser.home=${T}" eant -Dno.grammars="true" -DruntimeLibDirectory="target/lib/compile" \
	 -DtoolsLibDirectory="target/lib/compile" -DtestLibDirectory="target/lib/compile" -DskipFetch="true" doc
}

src_test() {
	cd "${S}/target/lib" && mkdir test && mkdir extras && cd compile

	java-pkg_jar-from --build-only ant-junit,jmock-1.0,xmlunit-1,hsqldb,commons-logging,cglib-2.1

	cd "${S}"
	ANT_TASKS="ant-junit ant-antlr ant-trax" ANT_OPTS="-Duser.home=${T}" eant \
		-DruntimeLibDirectory="target/lib/compile" -DtestLibDirectory="target/lib/compile" -DskipFetch="true" test
}

src_install() {
	java-pkg_newjar "target/dist/${PN}.jar"
	use doc && java-pkg_dojavadoc "target/html/groovy-jdk/"

	# FIXME: install those two later
	#
	#use doc && java-pkg_dojavadoc "target/html/api/"
	#use doc && java-pkg_dojavadoc "target/html/gapi/"

	use source && java-pkg_dosrc "src/main/groovy" "src/main/org"
	java-pkg_dolauncher "groovyc" --main org.codehaus.groovy.tools.FileSystemCompiler
	java-pkg_dolauncher "groovy" --main groovy.ui.GroovyMain
	java-pkg_dolauncher "groovysh" --main groovy.ui.InteractiveShell
	java-pkg_dolauncher "groovyConsole" --main groovy.ui.Console
	java-pkg_dolauncher "grape" --main org.codehaus.groovy.tools.GrapeMain
}
