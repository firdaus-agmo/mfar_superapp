/// Enum representing the main categories (classes) of bridge methods
/// that the web miniapp can call.
enum DefaultMiniAppBridgeClass {
  superAppUI('superAppUI'),
  superAppCamera('superAppCamera'),
  superAppLocation('superAppLocation'),
  superAppPermission('superAppPermission'),
  superAppBase('superAppBase'),
  superAppAuth('superAppAuth'),
  superAppPayment('superAppPayment');

  final String value;
  const DefaultMiniAppBridgeClass(this.value);
}
