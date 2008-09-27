# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-control-center/gnome-control-center-2.22.1.ebuild,v 1.3 2008/05/24 15:45:27 mr_bones_ Exp $

EAPI="1"

inherit autotools eutils gnome2

DESCRIPTION="The gnome2 Desktop configuration tool"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="eds hal sound"

# FIXME: eel is still needed for now?! ChangeLog and configure.in say different
# things
RDEPEND=">=virtual/xft-2.1.2
		 >=x11-libs/gtk+-2.11.6
		 >=dev-libs/glib-2.15.5
		 >=gnome-base/gconf-2.0
		 >=gnome-base/libglade-2
		 >=gnome-base/librsvg-2.0
		 >=gnome-base/nautilus-2.6
		 >=media-libs/fontconfig-1
		 >=dev-libs/dbus-glib-0.73
		 >=x11-libs/libxklavier-3.6
		 >=x11-wm/metacity-2.23.1
		 >=gnome-base/gnome-panel-2.0
		 >=gnome-base/libgnomekbd-2.21.4.1
		 >=gnome-base/gnome-desktop-2.23.90
		 >=gnome-base/gnome-menus-2.11.1
		 gnome-base/eel
		 gnome-base/gnome-settings-daemon

		>=media-libs/gstreamer-0.10.1.2
		>=media-libs/gst-plugins-base-0.10.1.2
		>=media-plugins/gst-plugins-gconf-0.10
		media-plugins/gst-plugins-meta:0.10

		x11-libs/pango
		dev-libs/libxml2
		media-libs/freetype

		eds? ( >=gnome-extra/evolution-data-server-1.7.90 )
		hal? ( >=sys-apps/hal-0.5.6 )
		sound? ( >=media-libs/libcanberra-0.4 )

		>=gnome-base/libbonobo-2
		>=gnome-base/libgnome-2.2
		>=gnome-base/libbonoboui-2
		>=gnome-base/libgnomeui-2.2

		x11-apps/xmodmap
		x11-libs/libXScrnSaver
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/libXxf86misc
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXcursor"
DEPEND="${RDEPEND}
		x11-proto/scrnsaverproto
		x11-proto/xextproto
		x11-proto/xproto
		x11-proto/xf86miscproto
		x11-proto/kbproto
		x11-proto/randrproto
		x11-proto/renderproto

		sys-devel/gettext
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.19
		dev-util/desktop-file-utils

		app-text/scrollkeeper
		>=app-text/gnome-doc-utils-0.10.1"
# Needed for autoreconf
#		gnome-base/gnome-common

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	if use sound && ! built_with_use media-libs/libcanberra gtk; then
		eerror "You need to rebuild media-libs/libcanberra with gtk support."
		die "Rebuild media-libs/libcanberra with USE='gtk'"
	fi

	G2CONF="${G2CONF}
		--disable-update-mimedb
		--enable-gstreamer=0.10
		$(use_enable eds aboutme)
		$(use_enable hal)
		$(use_with sound libcanberra)"
}