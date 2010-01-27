# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools gnome2 eutils

DESCRIPTION="The GObject introspection"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="" #doc

RDEPEND=">=dev-libs/glib-2.19.0
	|| (
		sys-devel/gcc[libffi]
		virtual/libffi )
	>=dev-lang/python-2.5"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.18
	sys-devel/flex"
#fails on parallel build. Look #293247
#	doc? ( >=dev-util/gtk-doc-1.13 )"

G2CONF="${G2CONF}
--disable-gtk-doc
--disable-static"

src_prepare() {
	gnome2_src_prepare

	# Make it libtool-1 compatible, bug #270909
	rm -v m4/lt* m4/libtool.m4 || die "removing libtool macros failed"

	eautoreconf
}

