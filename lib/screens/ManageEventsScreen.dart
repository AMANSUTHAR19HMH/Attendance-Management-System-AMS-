import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageEventsScreen extends StatefulWidget {
  const ManageEventsScreen({super.key});

  @override
  _ManageEventsScreenState createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  final CollectionReference eventsCollection = FirebaseFirestore.instance.collection('public_events');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Events'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventsCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(event['name']),
                subtitle: Text('Date: ${event['start_date']} - ${event['end_date']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    eventsCollection.doc(event.id).delete();
                  },
                ),
                onTap: () {
                  _editEventDialog(context, event);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEventDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addEventDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController organizationController = TextEditingController();
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: organizationController,
                  decoration: const InputDecoration(labelText: 'Organization'),
                ),
                TextField(
                  controller: startDateController,
                  decoration: const InputDecoration(labelText: 'Start Date'),
                ),
                TextField(
                  controller: endDateController,
                  decoration: const InputDecoration(labelText: 'End Date'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final String name = nameController.text;
                final String location = locationController.text;
                final String organization = organizationController.text;
                final String startDate = startDateController.text;
                final String endDate = endDateController.text;
                final String description = descriptionController.text;

                if (name.isNotEmpty &&
                    location.isNotEmpty &&
                    organization.isNotEmpty &&
                    startDate.isNotEmpty &&
                    endDate.isNotEmpty &&
                    description.isNotEmpty) {
                  eventsCollection.add({
                    'name': name,
                    'location': location,
                    'organization': organization,
                    'start_date': startDate,
                    'end_date': endDate,
                    'description': description,
                  });

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editEventDialog(BuildContext context, DocumentSnapshot event) {
    final TextEditingController nameController = TextEditingController(text: event['name']);
    final TextEditingController locationController = TextEditingController(text: event['location']);
    final TextEditingController organizationController = TextEditingController(text: event['organization']);
    final TextEditingController startDateController = TextEditingController(text: event['start_date']);
    final TextEditingController endDateController = TextEditingController(text: event['end_date']);
    final TextEditingController descriptionController = TextEditingController(text: event['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: organizationController,
                  decoration: const InputDecoration(labelText: 'Organization'),
                ),
                TextField(
                  controller: startDateController,
                  decoration: const InputDecoration(labelText: 'Start Date'),
                ),
                TextField(
                  controller: endDateController,
                  decoration: const InputDecoration(labelText: 'End Date'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final String name = nameController.text;
                final String location = locationController.text;
                final String organization = organizationController.text;
                final String startDate = startDateController.text;
                final String endDate = endDateController.text;
                final String description = descriptionController.text;

                if (name.isNotEmpty &&
                    location.isNotEmpty &&
                    organization.isNotEmpty &&
                    startDate.isNotEmpty &&
                    endDate.isNotEmpty &&
                    description.isNotEmpty) {
                  eventsCollection.doc(event.id).update({
                    'name': name,
                    'location': location,
                    'organization': organization,
                    'start_date': startDate,
                    'end_date': endDate,
                    'description': description,
                  });

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
