# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/seahorse/seahorse-2.22.3.ebuild,v 1.2 2008/07/14 18:50:07 aballier Exp $

EAPI="1"

inherit autotools eutils gnome2 subversion

ESVN_REPO_URI="http://svn.gnome.org/svn/${PN}/trunk"

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="http://www.gnome.org/projects/seahorse/index.html"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="avahi debug ldap libnotify"

RDEPEND="
		 >=gnome-base/libglade-2.0
		 >=gnome-base/gconf-2.0
		 >=dev-libs/glib-2.10
		 >=x11-libs/gtk+-2.10
		 net-libs/libsoup:2.4
		 || (
		 	=app-crypt/gnupg-1.4*
			=app-crypt/gnupg-2.0* )
		 >=app-crypt/gpgme-1.0.0
		   net-misc/openssh
		 avahi? ( >=net-dns/avahi-0.6 )
		 >=dev-libs/dbus-glib-0.72
		 >=gnome-base/gnome-keyring-2.23.6
		 ldap? ( net-nds/openldap )
		 libnotify? ( >=x11-libs/libnotify-0.3.2 )
		   x11-misc/shared-mime-info"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=app-text/gnome-doc-utils-0.3.2
		>=app-text/scrollkeeper-0.3
		>=dev-util/pkgconfig-0.20
		>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README TODO THANKS"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-pgp
		--enable-ssh
		--enable-pkcs11
		--disable-scrollkeeper
		--disable-update-mime-database
		--enable-hkp
		$(use_enable avahi sharing)
		$(use_enable debug)
		$(use_enable ldap)
		$(use_enable libnotify)"
}

src_unpack() {
	subversion_src_unpack
	gnome2_omf_fix
	gnome-doc-prepare --force || "gnome-doc-prepare failed"
	intltoolize --force || die "intltoolize failed"
	eautoreconf
}

src_install() {
	gnome2_src_install

	# remove conflicts with x11-misc/shared-mime-info
	rm -rf "${D}/usr/share/mime/"{application,magic,globs,XMLnamespaces}

	chmod -s "${D}/usr/bin/seahorse-agent"
	chmod -s "${D}/usr/bin/seahorse-daemon"

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/70-seahorse-agent"
}