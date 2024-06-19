include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-showshow
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-showshow
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=file transfer tool
  PKGARCH:=all
endef

define Package/luci-app-showshow/description
    This package provides a custom web interface for OpenWRT to monitor system status and configure WiFi settings.
endef

define Build/Prepare
  mkdir -p $(PKG_BUILD_DIR)
  cp -r $(CURDIR)/* $(PKG_BUILD_DIR)/
endef

# No compilation needed
#define Build/Compile
#  $(MAKE) -C $(PKG_BUILD_DIR)
#endef

define Package/luci-app-showshow/install
  $(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
  $(INSTALL_DATA) $(PKG_BUILD_DIR)/usr/lib/lua/luci/controller/mypackage.lua $(1)/usr/lib/lua/luci/controller/showshow.lua

  $(INSTALL_DIR) $(1)/www
  $(INSTALL_DATA) $(PKG_BUILD_DIR)/www/index.html $(1)/www/
  $(INSTALL_DATA) $(PKG_BUILD_DIR)/www/cgi-bin/script.lua $(1)/www/cgi-bin/
endef

$(eval $(call BuildPackage,luci-app-showshow))
