import 'package:flutter/material.dart';

class DownloadRideScriptTile extends StatelessWidget {
  final VoidCallback onTap;
  final Color iconColor;
  final double iconSize;
  final String title;

  const DownloadRideScriptTile({
    super.key,
    required this.onTap,
    this.iconColor = Colors.black,
    this.iconSize = 16,
    this.title = "Download Ride Script",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal:  8.0),
        child: Row(
          children: [
            Icon(
              Icons.file_copy,
              color: iconColor,
              size: iconSize,
            ),
            SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
