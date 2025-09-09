import 'package:flutter_test/flutter_test.dart';
import 'package:mfar_superapp/viewmodels/home_viewmodel.dart'; // Import your ViewModel

void main() {
  group('HomeViewModel', () {
    late HomeViewModel viewModel; // Declare a variable for the ViewModel

    setUp(() {
      // This runs before each test in this group
      viewModel = HomeViewModel(); // Create a new instance for each test
    });

    test('initial url is set correctly', () {
      // Test that the initial URL is the default one
      expect(viewModel.url, 'https://flutter.dev');
    });

    test('updateUrl updates the url', () {
      // Test that calling updateUrl changes the internal state
      final newUrl = 'https://example.com';
      viewModel.updateUrl(newUrl);

      expect(viewModel.url, newUrl);
    });

    test('isValidUrl returns true for valid URLs', () {
      // Test valid URLs
      viewModel.updateUrl('https://example.com');
      expect(viewModel.isValidUrl(), isTrue);

      viewModel.updateUrl('http://example.com');
      expect(viewModel.isValidUrl(), isTrue);

      viewModel.updateUrl('https://www.example.com/path?query=1');
      expect(viewModel.isValidUrl(), isTrue);
    });

    test('isValidUrl returns false for invalid URLs', () {
      // Test invalid URLs
      viewModel.updateUrl(''); // Empty string
      expect(viewModel.isValidUrl(), isFalse);

      viewModel.updateUrl('   '); // Whitespace only
      expect(viewModel.isValidUrl(), isFalse);

      viewModel.updateUrl('example.com'); // Missing scheme
      expect(viewModel.isValidUrl(), isFalse);

      viewModel.updateUrl('ftp://example.com'); // Unsupported scheme
      expect(viewModel.isValidUrl(), isFalse);

      viewModel.updateUrl('https://'); // Scheme only
      expect(viewModel.isValidUrl(), isFalse);
    });

    // Note: Testing launchMiniApp is more complex as it requires a BuildContext
    // and interacts with Navigator and ScaffoldMessenger. This typically requires
    // integration tests or more advanced mocking setup with mocktail or similar.
    // For unit testing the ViewModel logic, the above tests are sufficient.
  });
}
