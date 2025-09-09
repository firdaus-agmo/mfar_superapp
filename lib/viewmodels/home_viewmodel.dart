import 'package:flutter/material.dart';
import 'package:mfar_miniapp/mfar_miniapp.dart';

class HomeViewModel extends ChangeNotifier {
  String _url = 'https://flutter.dev';

  String get url => _url;

  void updateUrl(String newUrl) {
    _url = newUrl;
    notifyListeners();
  }

  bool isValidUrl() {
    final trimmedUrl = _url.trim();
    if (trimmedUrl.isEmpty) {
      return false;
    }
    final uri = Uri.tryParse(trimmedUrl);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https') && uri.host.isNotEmpty;
  }

  void launchMiniApp(BuildContext context) {
    if (isValidUrl()) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MfarWebViewMiniApp(initialUrl: _url)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid URL (starting with http:// or https://)'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
