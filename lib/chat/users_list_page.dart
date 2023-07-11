import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_page.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> fetchUsersData() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Register').get();

    final List<Map<String, dynamic>> users = [];
    for (var document in querySnapshot.docs) {
      final userData = document.data() as Map<String, dynamic>;
      final String userId = userData['uid'] ?? '';

      // Exclude the current user from the list
      if (userId != currentUserId) {
        users.add(userData);
      }
    }

    return users;
  }

  void navigateToMessagePage(String recipientUserId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagePage(recipientUserId: recipientUserId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text(
          'Users List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUsersData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<Map<String, dynamic>> users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(
              child: Text('No users found.'),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final userData = users[index];
              final String name = userData['name'] ?? '';
              final String email = userData['email'] ?? '';
              final String address = userData['address'] ?? '';
              final String userId = userData['uid'] ?? '';

              return ListTile(
                title: Text(name),
                subtitle: Text(email),
                trailing: Text(address),
                onTap: () {
                  navigateToMessagePage(userId);
                },
              );
            },
          );
        },
      ),
    );
  }
}
