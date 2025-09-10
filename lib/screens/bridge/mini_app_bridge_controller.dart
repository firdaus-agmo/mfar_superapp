import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'bridge_response.dart';

/// Type definition for a bridge method handler.
/// It takes a Map of parameters and returns a Future BridgeResponse.
typedef BridgeMethodHandler = Future<BridgeResponse> Function(Map<String, dynamic>? params);

/// Central controller for managing MiniApp bridge methods and processing requests.
///
/// This class holds a registry of available bridge methods (identified by class and method name)
/// and handles incoming JSON messages from the WebView, routing them to the correct handler.
class MiniAppBridgeController {
  // Registry to store registered methods
  // Key: ClassName_MethodName (e.g., 'superAppLocation_getLocation')
  // Value: The handler function
  final Map<String, BridgeMethodHandler> _methodRegistry = {};

  /// Registers a new bridge method handler.
  ///
  /// [className] The category/class of the method (e.g., 'superAppLocation').
  /// [methodName] The specific method name (e.g., 'getLocation').
  /// [handler] The async function that implements the method's logic.
  void registerMethod(String className, String methodName, BridgeMethodHandler handler) {
    final key = '$className#$methodName'; // Create a unique key
    _methodRegistry[key] = handler;
    debugPrint('Registered bridge method: $key');
  }

  /// Unregisters a bridge method handler.
  ///
  /// [className] The category/class of the method.
  /// [methodName] The specific method name.
  void unregisterMethod(String className, String methodName) {
    final key = '$className#$methodName';
    _methodRegistry.remove(key);
    debugPrint('Unregistered bridge method: $key');
  }

  /// Unregisters all registered methods.
  /// Useful for cleanup.
  void unregisterAll() {
    _methodRegistry.clear();
    debugPrint('Unregistered all bridge methods.');
  }

  /// Processes an incoming JSON request message from the WebView.
  ///
  /// [message] The raw JSON string received via the JavascriptChannel.
  /// Returns a JSON string response to be sent back to the WebView.
  Future<String> processRequest(String message) async {
    try {
      // 1. Decode the incoming JSON message
      final Map<String, dynamic> requestData = jsonDecode(message);

      // 2. Extract required fields (class, method) and optional params
      final String? className = requestData['class'];
      final String? methodName = requestData['method'];
      final Map<String, dynamic>? params = requestData['params'] is Map<String, dynamic>
          ? requestData['params'] as Map<String, dynamic>
          : null; // Ensure params is a Map or null

      // 3. Validate the request structure
      if (className == null || methodName == null) {
        debugPrint('Invalid request format: Missing class or method.');
        return BridgeResponse.error('Invalid request: Missing class or method.').toString();
      }

      // 4. Create the lookup key
      final String key = '$className#$methodName';

      // 5. Find the registered handler
      final BridgeMethodHandler? handler = _methodRegistry[key];

      // 6. Execute the handler or return an error if not found
      if (handler != null) {
        debugPrint('Executing bridge method: $key with params: $params');
        try {
          // 7. Await the handler's result
          final BridgeResponse response = await handler(params);
          debugPrint('Bridge method $key executed successfully.');
          return response.toString(); // Convert response to JSON string
        } catch (e, stackTrace) {
          debugPrint('Error executing bridge method $key: $e\nStack Trace: $stackTrace');
          return BridgeResponse.error('Internal error in method $methodName: $e').toString();
        }
      } else {
        debugPrint('Bridge method not found: $key');
        return BridgeResponse.error('Method not found: $className.$methodName').toString();
      }
    } catch (e, stackTrace) {
      // 8. Handle JSON parsing errors or other unexpected issues
      debugPrint('Error processing request: $e\nStack Trace: $stackTrace');
      return BridgeResponse.error('Malformed request or processing error: $e').toString();
    }
  }
}
