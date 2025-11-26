import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WifiHistoryPage extends StatefulWidget {
  const WifiHistoryPage({Key? key}) : super(key: key);

  @override
  _WifiHistoryPageState createState() => _WifiHistoryPageState();
}

class _WifiHistoryPageState extends State<WifiHistoryPage> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString('wifi_history');
    if (historyString != null) {
      setState(() {
        _history = List<Map<String, dynamic>>.from(json.decode(historyString));
      });
    }
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Connection History'),
      ),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                'No connection history found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                final connectedAt = DateTime.parse(item['connectedAt']);
                final disconnectedAt = item['disconnectedAt'] != null
                    ? DateTime.parse(item['disconnectedAt'])
                    : null;
                final duration = disconnectedAt?.difference(connectedAt).inSeconds ?? 0;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.wifi, color: Colors.blueAccent),
                    title: Text(
                      'Connected to ${item['ssid']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Connected: ${connectedAt.toLocal()}'),
                        if (disconnectedAt != null)
                          Text('Disconnected: ${disconnectedAt.toLocal()}'),
                        if (duration > 0)
                          Text('Duration: ${_formatDuration(duration)}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
