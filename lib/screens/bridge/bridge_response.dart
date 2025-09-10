import 'dart:convert';

/// A class to structure responses sent back to the web miniapp.
class BridgeResponse {
  final Map<String, dynamic> _data;

  BridgeResponse._(this._data);

  /// Creates a success response.
  /// Optionally include data.
  static BridgeResponse success([Map<String, dynamic>? data]) {
    final Map<String, dynamic> response = {'success': true};
    if (data != null) {
      response.addAll(data);
    }
    return BridgeResponse._(response);
  }

  /// Creates an error response.
  /// Include an error message.
  static BridgeResponse error(String message) {
    return BridgeResponse._({'success': false, 'error': message});
  }

  /// Converts the response to a JSON string suitable for sending via JavaScript.
  @override
  String toString() {
    return jsonEncode(_data);
  }
}
