// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class BrowserInfo {
  final num version;
  final String browser;
  final String platform;
  final String mobileType;  
  String _vendorPrefix;
  
  BrowserInfo(this.browser, this.version, this.platform, this.mobileType){
    _vendorPrefix = Browser.vendorPrefixMap[browser];
  }
  
  String get vendorPrefix => _vendorPrefix;
  
  bool get isMobile => mobileType != Browser.UNKNOWN;
  
  String toString() => "Browser Info (Type: ${browser}, Version: ${version}, Platform: ${platform}, MobileType: ${mobileType})";

}
