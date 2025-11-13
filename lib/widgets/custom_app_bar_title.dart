import 'package:flutter/material.dart';

import 'custom_drawer.dart';

// Custom AppBar Page


// Custom AppBar Widget
class CustomAppBarTitle extends StatelessWidget implements PreferredSizeWidget { // Implement PreferredSizeWidget
  @override
  final Size preferredSize; // Implement preferredSize

  CustomAppBarTitle({Key? key})
      : preferredSize = Size.fromHeight(80), // Set the height of the AppBar
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // White color for the AppBar
      elevation: 0, // Remove the shadow
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.black), // Menu icon
        onPressed: () {
          Scaffold.of(context).openDrawer(); // Open the drawer when tapped
        },
      ),
      title: Text(
        'Custom AppBar', // Title text
        style: TextStyle(color: Colors.black), // Title color black
      ),
    );
  }
}
