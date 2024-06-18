include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-showshow
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-showshow
    SECTION:=luci
    CATEGORY:=Luci
    SUBMENU:=3. Applications
    TITLE:= song~s
    PKGARCH:=all
    
endef

define Package/mypackage/description
    This package provides a custom web interface for OpenWRT to monitor system status and configure WiFi settings.
endef

define Build/Compile
    # Nothing to compile
endef

define Package/mypackage/install
    $(INSTALL_DIR) $(1)/etc/config
    $(INSTALL_CONF) $(PKG_BUILD_DIR)/files/etc/config/mypackage $(1)/etc/config/mypackage

    $(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
    $(INSTALL_DATA) $(PKG_BUILD_DIR)/files/usr/lib/lua/luci/controller/mypackage.lua $(1)/usr/lib/lua/luci/controller/mypackage.lua

    $(INSTALL_DIR) $(1)/www/cgi-bin
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/files/www/cgi-bin/script.lua $(1)/www/cgi-bin/script.lua

    $(INSTALL_DIR) $(1)/www
    $(INSTALL_DATA) $(PKG_BUILD_DIR)/files/www/index.html $(1)/www/index.html
endef

$(eval $(call BuildPackage,mypackage))
