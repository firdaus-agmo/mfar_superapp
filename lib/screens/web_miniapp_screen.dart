import 'package:flutter/material.dart';
import 'package:mfar_superapp/screens/bridge/mini_app_bridge_controller.dart';
import 'package:mfar_superapp/screens/bridge/superapp_base_bridge_method.dart';
import 'package:mfar_superapp/screens/bridge/superapp_location_bridge_method.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebMiniAppScreen extends StatefulWidget {
  final String miniAppUrl;
  final String title;

  const WebMiniAppScreen({super.key, required this.miniAppUrl, this.title = 'Web MiniApp'});

  @override
  State<WebMiniAppScreen> createState() => _WebMiniAppScreenState();
}

class _WebMiniAppScreenState extends State<WebMiniAppScreen> {
  late final WebViewController _webViewController;
  late final MiniAppBridgeController _bridgeController;

  static const String _channelName = 'SuperAppChannel'; // Match JS

  @override
  void initState() {
    super.initState();
    // 1. Initialize the Bridge Controller
    _bridgeController = MiniAppBridgeController(); // Instantiate the controller

    // 2. Register the bridge methods
    _registerBridgeMethods();

    // 3. Initialize the WebView Controller
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('WebView page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('WebView page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView resource error: ${error.description}');
          },
        ),
      )
      // 4. Add the JavascriptChannel for communication
      ..addJavaScriptChannel(
        _channelName,
        onMessageReceived: (JavaScriptMessage message) async {
          debugPrint('Received message from WebView: ${message.message}');

          // 5. Pass the received message to the Bridge Controller for processing
          final String responseString = await _bridgeController.processRequest(message.message);

          // 6. Send the response back to the WebView
          await _sendResponseToWebView(responseString);
        },
      )
      // Load the web miniapp URL
      ..loadRequest(Uri.parse(widget.miniAppUrl));
  }

  void _registerBridgeMethods() {
    // Register methods from different bridge categories
    // Pass necessary dependencies like BuildContext
    registerSuperAppBaseBridgeMethod(_bridgeController, context);
    registerSuperAppLocationBridgeMethod(_bridgeController, context);
    // Add more registration calls here for other bridge categories
  }

  Future<void> _sendResponseToWebView(String response) async {
    try {
      // Call the global JS function defined in your web miniapp
      await _webViewController.runJavaScript(
        'window.receiveMessageFromSuperApp(\'${response.replaceAll("'", "\\'")}\');',
      );
      debugPrint('Sent response to WebView: $response');
    } catch (e) {
      debugPrint('Error sending response to WebView: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: WebViewWidget(controller: _webViewController),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
