import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WifiConnectionPage extends StatefulWidget {
  const WifiConnectionPage({Key? key}) : super(key: key);

  @override
  _WifiConnectionPageState createState() => _WifiConnectionPageState();
}

class _WifiConnectionPageState extends State<WifiConnectionPage> {
  String _connectionStatus = 'Disconnected';
  bool _isConnecting = false;
  bool _isConnected = false;

  // TODO: Replace with your WiFi credentials
  final String _ssid = 'Armans wife';
  final String _password = 'ramramji';

  Future<void> _connectToWifi() async {
    setState(() {
      _isConnecting = true;
      _connectionStatus = 'Connecting...';
    });

    try {
      bool isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
      if (!isWifiEnabled) {
        setState(() {
          _connectionStatus = 'Please enable WiFi';
          _isConnecting = false;
        });
        return;
      }

      await WiFiForIoTPlugin.disconnect();

      bool? isConnected = await WiFiForIoTPlugin.connect(
        _ssid,
        password: _password,
        security: NetworkSecurity.WPA,
      );

      if (isConnected == true) {
        setState(() {
          _connectionStatus = 'Connected to $_ssid';
          _isConnected = true;
        });
        await _saveConnectionHistory(connected: true);
      } else {
        setState(() {
          _connectionStatus = 'Failed to connect to $_ssid';
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  Future<void> _disconnectFromWifi() async {
    try {
      await WiFiForIoTPlugin.disconnect();
      setState(() {
        _connectionStatus = 'Disconnected';
        _isConnected = false;
      });
      await _saveConnectionHistory(connected: false);
    } catch (e) {
      setState(() {
        _connectionStatus = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> _saveConnectionHistory({required bool connected}) async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString('wifi_history');
    List<Map<String, dynamic>> history = [];
    if (historyString != null) {
      history = List<Map<String, dynamic>>.from(json.decode(historyString));
    }

    if (connected) {
      history.add({
        'ssid': _ssid,
        'connectedAt': DateTime.now().toIso8601String(),
        'disconnectedAt': null,
      });
    } else {
      if (history.isNotEmpty && history.last['disconnectedAt'] == null) {
        history.last['disconnectedAt'] = DateTime.now().toIso8601String();
      }
    }

    await prefs.setString('wifi_history', json.encode(history));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Connection'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                _isConnecting
                    ? 'assets/lottie/waving.json'
                    : _isConnected
                        ? 'assets/lottie/welcome.json'
                        : 'assets/lottie/avatar.json',
                height: 200,
              ),
              const SizedBox(height: 20),
              Text(
                'Status: $_connectionStatus',
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              if (!_isConnected)
                ElevatedButton(
                  onPressed: _isConnecting ? null : _connectToWifi,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: _isConnecting
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Connect to WiFi'),
                ),
              if (_isConnected)
                ElevatedButton(
                  onPressed: _disconnectFromWifi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Disconnect'),
                ),
              const SizedBox(height: 20),
              const Text(
                'Note: Replace "YOUR_SSID" and "YOUR_PASSWORD" in the code with your WiFi network credentials.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
