import 'package:flutter/material.dart';
import 'package:mfar_superapp/components/dialog.dart';
import 'mini_app_bridge_controller.dart';
import 'default_miniapp_bridge_class.dart';
import 'bridge_response.dart';

enum SuperAppBaseBridgeMethod {
  initialized('initialized'),
  showDialog('showDialog');

  final String value;
  const SuperAppBaseBridgeMethod(this.value);
}

/// Function to register base bridge methods with the controller.
/// This decouples the registration logic from the controller itself.
void registerSuperAppBaseBridgeMethod(
  MiniAppBridgeController bridgeController,
  BuildContext context, // Pass context if needed for UI actions like showing dialogs
) {
  // Register the 'initialized' method
  bridgeController.registerMethod(
    DefaultMiniAppBridgeClass.superAppBase.value, // Bridge Class
    SuperAppBaseBridgeMethod.initialized.value, // Method Name
    (params) async {
      // This method is called when the web miniapp sends { class: 'superAppBase', method: 'initialized' }
      debugPrint("Web MiniApp initialized signal received.");
      // You could perform initial setup here if needed.
      // For now, just send a success response.
      return BridgeResponse.success({'message': 'SuperApp acknowledged initialization'});
    },
  );

  bridgeController.registerMethod(
    DefaultMiniAppBridgeClass.superAppBase.value,
    SuperAppBaseBridgeMethod.showDialog.value,
    (params) async {
      // <--- This handler now has access to 'context' from the outer scope
      debugPrint("Web MiniApp requested to show dialog with params: $params");

      try {
        final String title = params?['title'] as String? ?? 'Dialog';
        final String message = params?['message'] as String? ?? 'Message';

        // 2. Show the dialog using the reusable component with the captured 'context'
        await CustomDialog.show(context, title: title, message: message, backgroundColor: Colors.grey);
        debugPrint("Dialog shown successfully.");

        return BridgeResponse.success({'shown': true});
      } catch (e, stackTrace) {
        debugPrint("Error showing dialog: $e\nStack Trace: $stackTrace");
        return BridgeResponse.error('Failed to show dialog: $e');
      }
    },
  );
}
