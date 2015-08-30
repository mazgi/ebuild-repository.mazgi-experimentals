# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="sbt, a build tool for Scala."
HOMEPAGE="http://scala-sbt.org"
SRC_URI="http://repo.scala-sbt.org/scalasbt/sbt-native-packages/org/scala-sbt/sbt/${PV}/sbt.tgz"

LICENSE="BSD"
SLOT="0.12"
KEYWORDS="amd64"

IUSE=""

DEPEND=">=virtual/jre-1.7"
RDEPEND="${DEPEND}"

src_unpack() {
	default

	mv "${WORKDIR}/sbt" "${S}" || die
}

src_install() {
	local dest="/opt/${P}"

	# Remove Windows batch file
	rm -f "${S}/bin/sbt.bat" || die

	insinto "${dest}"
	doins -r bin jansi-license.txt || die
	fperms 0755 "${dest}/bin/sbt" || die

	dosym "${dest}/bin/sbt" /usr/bin/sbt || die
}
