import 'package:flutter/material.dart';
import 'package:mfar_superapp/components/button.dart';
import 'package:mfar_superapp/components/textinput.dart';
import 'package:mfar_superapp/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:mfar_superapp/screens/web_miniapp_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstBuild) {
      _isFirstBuild = false;
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      _urlController.text = homeViewModel.url;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _onUrlChanged(String newText) {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    homeViewModel.updateUrl(newText);
  }

  void _onLaunchPressed() {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    homeViewModel.launchMiniApp(context);
  }

  void _openWebMiniApp() {
    final String webMiniAppUrl = 'https://firdaus-agmo.github.io/mfar_web_miniapp/';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebMiniAppScreen(miniAppUrl: webMiniAppUrl, title: 'My Web MiniApp'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('MFAR SuperApp'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Welcome to the MFAR SuperApp!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                CustomTextInput(
                  labelText: 'Enter URL',
                  hintText: 'https://example.com',
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  onChanged: _onUrlChanged,
                ),
                const SizedBox(height: 20),
                CustomButton(text: 'Open WebView MiniApp (URL Input)', onPressed: _onLaunchPressed),
                const SizedBox(height: 20),
                CustomButton(text: 'Open Web MiniApp (Hardcoded)', onPressed: _openWebMiniApp),
              ],
            ),
          ),
        );
      },
    );
  }
}
