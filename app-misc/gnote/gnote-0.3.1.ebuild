# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils gnome2

DESCRIPTION="Desktop note-taking application"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug" # dbus

RDEPEND=">=x11-libs/gtk+-2.14
	>=dev-cpp/glibmm-2
	>=dev-cpp/gtkmm-2.12
	>=dev-libs/libxml2-2
	>=dev-cpp/libxmlpp-2.6
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2
	>=app-text/gtkspell-2.0.9
	>=dev-libs/boost-1.34
	sys-libs/e2fsprogs-libs
	>=gnome-base/gnome-panel-2"
# Build with dbus is currently broken
#	>=dev-cpp/libpanelappletmm-2.22
#	dbus? ( >=dev-libs/dbus-glib-0.70 )"
DEPEND="${DEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35.0
	app-text/gnome-doc-utils"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_prepare() {
	gnome2_src_prepare

	# Update boost macro
	epatch ${FILESDIR}/${P}-boost-update-v10.patch

	# Fix failure ot build with -Wl,--as-needed
	epatch ${FILESDIR}/${P}-fix-ldflags-as-needed.patch

	# Fix automagic dependency on libpanelappletmm
	epatch "${FILESDIR}/${P}-automagic.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-dbus
		--disable-applet
		--disable-static
		$(use_enable debug)"
}