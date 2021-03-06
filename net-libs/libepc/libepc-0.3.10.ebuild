# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2

DESCRIPTION="Easy Publish and Consume library for network discovered services."
HOMEPAGE="http://live.gnome.org/libepc/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=net-dns/avahi-0.6[dbus,gtk]
	>=dev-libs/glib-2.15.1
	>=net-libs/gnutls-1.4
	>=sys-libs/e2fsprogs-libs-1.36
	>=x11-libs/gtk+-2.10
	>=net-libs/libsoup-2.3:2.4"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.14
	>=dev-util/intltool-0.35.0
	doc? ( >=dev-util/gtk-doc-1.4 )"

DOCS="AUTHORS ChangeLog NEWS README"
G2CONF="${G2CONF} --disable-static"

# FIXME: 2 out of 16 tests fail, upstream bug #578792
RESTRICT="test"

src_prepare() {
	gnome2_src_prepare

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed failed"
}

src_test() {
	unset DBUS_SYSTEM_BUS_ADDRESS
	emake check || die "emake check failed"
}
