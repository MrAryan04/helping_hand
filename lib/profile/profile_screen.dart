import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../auth/auth_page.dart';
import 'change_password.dart';
import 'edit_Profile.dart';
import 'Terms_conditons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: const Image(image: AssetImage('assets/login.png'))),
              ),

              const SizedBox(height: 10),
              Text(
                '${FirebaseAuth.instance.currentUser!.displayName}',
                style: const TextStyle(color: Colors.black),
              ),
              Text('${FirebaseAuth.instance.currentUser!.email}',
                  style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const EditProfile()),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(156, 64, 218, 1),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text('Edit Profile',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              //menu

              ProfileMenuWidget(
                title: "Delete Account",
                icon: LineAwesomeIcons.cog,
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Confirm Delete',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        'Are you sure you want to delete? This action cannot be undone',
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // To close the confirmation dialog
                            try {
                              await FirebaseAuth.instance.currentUser!
                                  .delete()
                                  .then((value) async {
                                await FirebaseAuth.instance.signOut();
                                await FirebaseFirestore.instance
                                    .collection('Register')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .delete()
                                    .then(
                                      (value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) =>
                                              const AuthPage()),
                                        ),
                                      ),
                                    );
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Error Deleting user. Please try again later!!!',
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'DELETE',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              ProfileMenuWidget(
                  title: "Change Password",
                  icon: LineAwesomeIcons.lock,
                  onPress: () {
                    // Navigator.pushNamed(context, 'ChangePassword');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const ChangePassword()),
                      ),
                    );
                  }),
              ProfileMenuWidget(
                  title: "Terms and Condition",
                  icon: LineAwesomeIcons.info,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                const TermsAndConditionsPage())));
                  }),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const AuthPage())));
                    FirebaseAuth.instance.signOut();
                    // Navigator.of(context).pop();
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(116, 192, 67, 1).withOpacity(0.1),
        ),
        child: Icon(icon, color: const Color.fromRGBO(156, 64, 218, 1)),
      ),
      title: Text(title,
          style:
              Theme.of(context).textTheme.bodyMedium?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.blue.withOpacity(0.1),
              ),
              child: const Icon(LineAwesomeIcons.angle_right,
                  size: 18.0, color: Colors.grey))
          : null,
    );
  }
}
