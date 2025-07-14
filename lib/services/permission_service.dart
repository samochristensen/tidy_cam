/// Stub service: bypass all permission checks and auto-grant.
class PermissionsService {
  /// Always returns true to simulate granted permissions.
  static Future<bool> checkPermissions() async => true;

  /// Always returns true to simulate successful permission request.
  static Future<bool> requestPermissions() async => true;
}
