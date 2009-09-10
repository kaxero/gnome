# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit autotools eutils gnome2 versionator

EAPI=2
MY_MAJORV=$(get_version_component_range 1-2)

DESCRIPTION="Extensions for the Epiphany web browser"
HOMEPAGE="http://www.gnome.org/projects/epiphany/extensions.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
# TODO: rss extension - re-add dbus USE
# epiphany has removed one symbol required to build this extension
IUSE="examples pcre"

RDEPEND=">=www-client/epiphany-${MY_MAJORV}
	app-text/opensp
	>=dev-libs/glib-2.15.5
	>=gnome-base/gconf-2.0
	>=dev-libs/libxml2-2.6
	>=x11-libs/gtk+-2.12.0
	>=gnome-base/libglade-2
	>=net-libs/webkit-gtk-1.1

	pcre? ( >=dev-libs/libpcre-3.9-r2 )"
	# TODO: rss
	# dbus? ( >=dev-libs/dbus-glib-0.34 )
DEPEND="${RDEPEND}
	  gnome-base/gnome-common
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.20
	>=app-text/gnome-doc-utils-0.3.2"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	local extensions=""

	# Not enabled:
	# 	* rss: ( fixed in >92, quite useless )
	# FIXME: broken extensions:
	#	* auto-scroller: ( http://bugzilla.gnome.org/show_bug.cgi?id=589560 )
	#   * gestures		 ( http://bugzilla.gnome.org/show_bug.cgi?id=563099 )
	#   * push-scroller: ( http://bugzilla.gnome.org/show_bug.cgi?id=594486 )
	#   * session-saver  ( http://bugzilla.gnome.org/show_bug.cgi?id=316245 )
	#   * sidebar: hangs ( http://bugzilla.gnome.org/show_bug.cgi?id=594481 )
	#   * ...and probably some more... :)
	extensions="actions adblock auto-reload certificates \
			   error-viewer extensions-manager-ui \
			   java-console livehttpheaders page-info permissions \
			   select-stylesheet \
			   smart-bookmarks soup-fly tab-groups tab-states"
	#use dbus && extensions="${extensions} rss"

	use pcre && extensions="${extensions} greasemonkey"

	use examples && extensions="${extensions} sample"

	G2CONF="${G2CONF} --with-extensions=$(echo "${extensions}" | sed -e 's/[[:space:]]\+/,/g')"

}

src_prepare() {
	# Fix building with libtool-1  bug #257337
	rm m4/lt* m4/libtool.m4

	# Fix adblock crasher (in upstream)
	epatch "${FILESDIR}/${P}-fix-adblock-crasher.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}