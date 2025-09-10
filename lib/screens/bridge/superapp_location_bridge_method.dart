import 'package:flutter/material.dart';
import 'package:mfar_superapp/screens/bridge/default_miniapp_bridge_class.dart';
import 'package:permission_handler/permission_handler.dart';
import 'mini_app_bridge_controller.dart';
import 'bridge_response.dart';

enum SuperAppLocationBridgeMethod {
  getLocation('getLocation');

  final String value;
  const SuperAppLocationBridgeMethod(this.value);
}

void registerSuperAppLocationBridgeMethod(MiniAppBridgeController bridgeController, BuildContext context) {
  // Register the 'getLocation' method
  bridgeController.registerMethod(
    DefaultMiniAppBridgeClass.superAppLocation.value, // Bridge Class
    SuperAppLocationBridgeMethod.getLocation.value, // Method Name
    (params) async {
      // This method is called when the web miniapp sends { class: 'superAppLocation', method: 'getLocation' }
      debugPrint("Web MiniApp requested location permission status.");

      try {
        // 1. Check the current permission status for location
        PermissionStatus status = await Permission.location.status;

        // 2. If status is denied, we can request permission
        // (Note: If it's permanentlyDenied, requesting won't work, user must go to settings)
        if (status == PermissionStatus.denied) {
          debugPrint("Location permission is denied. Requesting permission...");
          // Request the permission
          status = await Permission.location.request();
          debugPrint("Permission request result: $status");
        }

        // 3. Determine the final status string to send back
        String statusString;
        switch (status) {
          case PermissionStatus.granted:
          case PermissionStatus.limited: // iOS specific, treated as granted for simplicity here
            statusString = 'granted';
          case PermissionStatus.denied:
            statusString = 'denied';
          case PermissionStatus.permanentlyDenied:
            statusString = 'permanentlyDenied';
          case PermissionStatus.restricted: // iOS specific
            statusString = 'restricted';
          default:
            statusString = 'unknown';
        }

        debugPrint("Final Location permission status: $statusString");

        // 4. Send the status back to the web miniapp
        return BridgeResponse.success({'status': statusString});
      } catch (e) {
        debugPrint("Error checking/requesting location permission: $e");
        return BridgeResponse.error('Failed to check/request location permission: $e');
      }
    },
  );
}
