# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit user git-2 versionator

DESCRIPTION="A Example of Scala App with PlayFramework"
HOMEPAGE="http://mazgi.com"
EGIT_REPO_URI="https://github.com/mazgi-sandbox/HelloPlay.git"
SLOT="HEAD"

if [[ ${PV} != 9999 ]]; then
	# set tag as "EGIT_COMMIT"
	EGIT_COMMIT="v${PV}"
	SLOT=$(get_version_component_range 1-2)
fi

LICENSE="MIT"
KEYWORDS=""
IUSE="+symlink +autoclean doc"

use autoclean || AUTOCLEAN=no

DEPEND=">=dev-java/sbt-bin-0.13
>=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

DIST_NAME="helloplay"
DIST_VERSION="1.0-SNAPSHOT"

APP_DIR="/var/lib/${PN}"

pkg_setup() {
	enewgroup play || die
	enewuser play -1 -1 "${APP_DIR}" play || die
}

src_prepare() {
	# remove config files for development
	elog "Remove development configrations."
	rm -f "conf/[^routes]*" || die
}

src_compile() {
	rev=$(git rev-parse HEAD) || die
	sbt clean stage || die
}

src_install() {
	keepdir "/var/log/${PN}" "/etc/${PN}" || die
	keepdir "${APP_DIR}/versions/${PN}.${PV}.${rev}" || die

	local stage="target/universal/stage"
	insinto "${APP_DIR}/versions/${PN}.${PV}.${rev}"
	doins -r "${stage}/bin" || die
	doins -r "${stage}/lib" || die
	if use doc; then
		doins "${stage}/README.md" || die
		doins -r "${stage}/doc" || die
		doins -r "${stage}/share" || die
	fi

	newinitd "${FILESDIR}/${PN}.init2" "${PN}" || die
	newconfd "${FILESDIR}/${PN}.confd" "${PN}" || die
	cp "${FILESDIR}/application.conf.example" "${ED}/etc/${PN}/" || die "Cannot copy example application.conf"
	# replace log dir
	sed -e 's!<PLACEHOLDER_LOG_DIR>!/var/log/'${PN}'!' "${FILESDIR}/logger.xml" > "${ED}/etc/${PN}/logger.xml" || die

	dosym "/etc/${PN}" "${APP_DIR}/versions/${PN}.${PV}.${rev}/conf"
	dosym "/var/log/${PN}" "${APP_DIR}/versions/${PN}.${PV}.${rev}/logs"
	if use symlink; then
		dosym "${APP_DIR}/versions/${PN}.${PV}.${rev}" "${APP_DIR}/versions/current" || ewarn 'Exist symlink!'
	fi

	fowners -R play:play "${APP_DIR}" "/var/log/${PN}" || die
	fperms 0755 "${APP_DIR}/versions/${PN}.${PV}.${rev}/bin/${DIST_NAME}" || die
}
