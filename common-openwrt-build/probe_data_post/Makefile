#
# Copyright (C) 2006,2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=probe_data_post
PKG_VERSION:=0.0.2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_MD5SUM:=9fb82e4533931cc03ddeefe13211b414
PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/probe_data_post
  SECTION:=ProbeDataPost
  CATEGORY:=Probe
  DEPENDS:=+curl
  TITLE:=A tool to post probe data to the server
endef

define Package/probe_data_post/description
	a tool to post probe data to the server
endef


define Package/probe_data_post/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/post_mac_probe.sh  $(1)/usr/sbin/post_mac_probe
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/probe_data_post  $(1)/usr/sbin/probe_data_post
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/probe_data_post_conf  $(1)/etc/config/probe_data_post_conf
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DATA) ./files/probe_post_data_counter  $(1)/etc/.probe_post_data_counter
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/probepost $(1)/etc/init.d/probepost
endef

$(eval $(call BuildPackage,probe_data_post))
