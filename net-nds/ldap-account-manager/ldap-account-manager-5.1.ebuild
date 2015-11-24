# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit webapp

DESCRIPTION="LDAP Account Manager (LAM) is a webfrontend for managing entries (e.g. users, groups, DHCP settings) stored in an LDAP directory."
HOMEPAGE="https://www.ldap-account-manager.org/lamcms/"
SRC_URI="mirror://sourceforge/lam/${P}.tar.bz2"

LICENSE="GPL-2"
WEBAPP_MANUAL_SLOT="yes"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/php-5.3.2[ldap,xml,mhash,zip]"
RDEPEND="${DEPEND}"

src_install() {
	webapp_src_preinst

	insinto ${MY_HTDOCSDIR}
	doins VERSION
	doins -r config
	doins -r graphics
	doins -r help
	doins index.html
	doins -r lib
	doins -r locale
	doins -r sess
	doins -r style
	doins -r templates
	doins -r tmp

	webapp_src_install
}

