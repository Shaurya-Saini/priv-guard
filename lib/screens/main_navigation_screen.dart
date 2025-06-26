import 'package:flutter/material.dart';
import 'gallery_screen.dart';
import 'social_media_scanner_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    GalleryScreen(),
    SocialMediaScannerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _screens[_currentIndex],
          ),
          // Footer section
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: Text(
              '© 2024 PrivGuard - Your Privacy Guardian',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF94A3B8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gpp_maybe),
            label: 'Scan Socials',
          ),
        ],
        selectedItemColor: Color(0xFF0C7FF2),
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
}
