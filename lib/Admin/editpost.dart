import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class EditPost extends StatefulWidget {
  final String postId;

  const EditPost({super.key, required this.postId});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  String? name;
  String? description;
  DateTime? publishedDate;

  @override
  void initState() {
    super.initState();
    // Retrieve the existing review data from Firestore
    FirebaseFirestore.instance
        .collection('Post')
        .doc(widget.postId)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? reviewData = documentSnapshot.data();

        // Set the variables with existing data
        setState(() {
          name = reviewData?['name'];
          description = reviewData?['description'];

          publishedDate = reviewData?['publishedDate']?.toDate();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: name,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: description,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Repeat the above pattern for other fields (actor, review, reviewBy, genre, publishedDate)
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update the review data in Firestore
                FirebaseFirestore.instance
                    .collection('Post')
                    .doc(widget.postId)
                    .update({
                  'name': name,
                  'description': description,
                  'publishedDate': publishedDate,
                }).then((value) {
                  // Review updated successfully
                  Navigator.pop(context); // Return to the previous screen
                }).catchError((error) {
                  // An error occurred while updating the review
                  // You can show an error message to the user
                });
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
