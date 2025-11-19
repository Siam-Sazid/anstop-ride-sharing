import 'package:flutter/material.dart';

class DriverStatusWidget extends StatefulWidget {
  final String statusText;
  final String? time;
  final Color circleColor;

  const DriverStatusWidget({
    Key? key,
    required this.statusText,
     this.time,
    this.circleColor = Colors.green,  // Default to green circle if not specified
  }) : super(key: key);

  @override
  _DriverStatusWidgetState createState() => _DriverStatusWidgetState();
}

class _DriverStatusWidgetState extends State<DriverStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 5.0,  // Circle width
            height: 5.0,  // Circle height
            decoration: BoxDecoration(
              color: widget.circleColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.0),
          Text(
            widget.statusText,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          if (widget.time != null)
          Container(
            width: 50.0,
            color: Colors.black,
            child: Center(
              child: Text(
                widget.time!,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
