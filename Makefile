include $(TOPDIR)/rules.mk

PKG_NAME:=my-package
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/my-package
    SECTION:=net
    CATEGORY:=Network
    TITLE:=My custom OpenWRT package
    MAINTAINER:=Your Name <3014602014@qq.com>
endef

define Package/my-package/description
    This package provides a custom web interface for OpenWRT to monitor system status and configure WiFi settings.
endef

define Build/Compile
    # Nothing to compile
endef

define Package/my-package/install
    $(INSTALL_DIR) $(1)/etc/config
    $(INSTALL_CONF) $(PKG_BUILD_DIR)/files/etc/config/showshow $(1)/etc/config/showshow

    $(INSTALL_DIR) $(1)/www/cgi-bin
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/files/www/cgi-bin/script.lua $(1)/www/cgi-bin/script.lua

    $(INSTALL_DIR) $(1)/www
    $(INSTALL_DATA) $(PKG_BUILD_DIR)/files/www/index.html $(1)/www/index.html
endef

$(eval $(call BuildPackage,showshow))
