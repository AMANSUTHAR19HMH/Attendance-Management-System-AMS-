import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  final CollectionReference publicEventsCollection =
      FirebaseFirestore.instance.collection('public_events');

  EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: publicEventsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Card(
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: ListTile(
                    title: Text(event['name'] ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: ${event['location'] ?? 'No Location'}'),
                        Text(
                            'Organization: ${event['organization'] ?? 'No Organization'}'),
                        Text(
                            'Start Date: ${event['start_date'] ?? 'No Start Date'}'),
                        Text('End Date: ${event['end_date'] ?? 'No End Date'}'),
                        Text(
                            'Description: ${event['description'] ?? 'No Description'}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
