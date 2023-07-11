import 'package:flutter/material.dart';
import '../chat/users_list_page.dart';
import '../home/Home.dart';
import '../profile/profile_screen.dart';

class Navbar extends StatefulWidget {
  final int? index;
  const Navbar({super.key, this.index});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;
  final screen = const [
    HomePage(),
    UsersListPage(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) => setState(() => selectedIndex = index),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screen,
      ),
    );
  }
}
