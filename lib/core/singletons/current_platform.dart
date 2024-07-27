class CurrentPlatform {
  factory CurrentPlatform({required bool isMobile}) {
    instance._isMobile = isMobile;
    instance._isDesktop = !isMobile;
    return instance;
  }
  CurrentPlatform._internal();

  static final CurrentPlatform instance = CurrentPlatform._internal();

  bool _isMobile = false;
  bool _isDesktop = false;

  bool get isMobile => _isMobile;
  bool get isDesktop => _isDesktop;
}
