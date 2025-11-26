import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ridelink/pages/wifi_connection_page.dart';
import 'package:ridelink/pages/wifi_history_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPassengerCountCard(),
            const SizedBox(height: 20),
            _buildRecentEvents(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.wifi),
              label: const Text("WiFi Connection"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WifiConnectionPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text("Connection History"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WifiHistoryPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerCountCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('passenger_count')
              .doc('current')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("No passenger data available"));
            }

            final data = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live Passenger Count',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    data['total']?.toString() ?? '0',
                    style: const TextStyle(
                        fontSize: 60, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('RFID: ${data['rfid'] ?? 'N/A'}'),
                    Text('WiFi: ${data['wifi'] ?? 'N/A'}'),
                  ],
                ),
                const SizedBox(height: 5),
                if (data['timestamp'] != null)
                  Text(
                      'Last updated: ${((data['timestamp']) as Timestamp).toDate()}'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecentEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Events',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('events')
                .orderBy('timestamp', descending: true)
                .limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.requireData;

              if (data.size == 0) {
                return const Center(child: Text("No recent events."));
              }

              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  final event = data.docs[index];
                  final eventData = event['data'] as Map<String, dynamic>? ?? {};
                  final timestamp = eventData['timestamp'] as Timestamp? ?? event['timestamp'] as Timestamp;
                  
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text('Event Type: ${eventData['type'] ?? 'N/A'}'),
                      subtitle: Text('UID: ${eventData['uid'] ?? 'N/A'}'),
                      trailing: Text(
                          '${timestamp.toDate().toLocal()}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
