import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

        // 3. Prepare base response data
        final Map<String, dynamic> responseData = {'status': _mapPermissionStatusToString(status)};

        // 4. If permission is granted (or limited on iOS), try to get the location
        if (status == PermissionStatus.granted || status == PermissionStatus.limited) {
          try {
            // --- Use Geolocator or your LocationHandler ---
            // Example using Geolocator:
            // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
            // if (!serviceEnabled) {
            //   responseData['error'] = 'Location services are disabled.';
            // } else {
            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high, // Adjust as needed
            );
            // Add location data to the response
            responseData['latitude'] = position.latitude;
            responseData['longitude'] = position.longitude;
            responseData['timestamp'] = position.timestamp.toIso8601String(); // Optional
            // You could add accuracy, altitude, etc. if needed
            debugPrint("Location acquired: ${position.latitude}, ${position.longitude}");
            // }
            // --- End Geolocator ---
          } catch (locationError) {
            debugPrint("Error getting location data: $locationError");
            // Even if permission is granted, getting the location might fail
            responseData['error'] = 'Failed to get location data: $locationError';
            // Status remains 'granted', but data fetch failed
          }
        } else {
          // If not granted, no location data will be included.
          // The status string already reflects this (denied, permanentlyDenied, etc.)
        }

        // 5. Send the combined response (status, potentially location data, potentially error)
        debugPrint("Sending location response to web miniapp: $responseData");
        return BridgeResponse.success(responseData);
      } catch (e, stackTrace) {
        debugPrint("Error in getLocation handler: $e\nStack Trace: $stackTrace");
        return BridgeResponse.error('Failed to check/request location or get data: $e');
      }
    },
  );
}

// Helper function to map PermissionStatus to a consistent string
String _mapPermissionStatusToString(PermissionStatus status) {
  switch (status) {
    case PermissionStatus.granted:
    case PermissionStatus.limited: // iOS specific, treat as granted for simplicity here
      return 'granted';
    case PermissionStatus.denied:
      return 'denied';
    case PermissionStatus.permanentlyDenied:
      return 'permanentlyDenied';
    case PermissionStatus.restricted: // iOS specific
      return 'restricted';
    default:
      return 'unknown';
  }
}
