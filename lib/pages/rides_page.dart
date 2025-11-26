import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RidesPage extends StatelessWidget {
  const RidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rides History'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('trips').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              final trip = data.docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.directions_bus),
                  title: Text(trip['name'] ?? 'Unnamed Ride'),
                  subtitle: Text(
                      'From: ${trip['source']}\nDuration: ${trip['duration_min']} mins'),
                  trailing: Text('Fare: ${trip['fare']}'),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

