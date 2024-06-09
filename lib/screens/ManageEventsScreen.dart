import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageEventsScreen extends StatefulWidget {
  @override
  _ManageEventsScreenState createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  final CollectionReference eventsCollection = FirebaseFirestore.instance.collection('public_events');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Events'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventsCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
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
                  icon: Icon(Icons.delete),
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
        child: Icon(Icons.add),
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
          title: Text('Add Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: organizationController,
                  decoration: InputDecoration(labelText: 'Organization'),
                ),
                TextField(
                  controller: startDateController,
                  decoration: InputDecoration(labelText: 'Start Date'),
                ),
                TextField(
                  controller: endDateController,
                  decoration: InputDecoration(labelText: 'End Date'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
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
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
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
          title: Text('Edit Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: organizationController,
                  decoration: InputDecoration(labelText: 'Organization'),
                ),
                TextField(
                  controller: startDateController,
                  decoration: InputDecoration(labelText: 'Start Date'),
                ),
                TextField(
                  controller: endDateController,
                  decoration: InputDecoration(labelText: 'End Date'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
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
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
