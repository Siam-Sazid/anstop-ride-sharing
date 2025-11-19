import 'package:flutter/material.dart';

import '../../../app/utils/app_colors.dart';


class BlockDialog extends StatelessWidget {
  final String userName;
  final VoidCallback onBlock;
  final VoidCallback onCancel;

  const BlockDialog({
    Key? key,
    required this.userName,
    required this.onBlock,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with red "Block" text
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Delete',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: MessagingColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // Block text in red
            const Text(
              'Block',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: MessagingColors.darkRed,
              ),
            ),

            const SizedBox(height: 20),

            // Confirmation message
            Text(
              'Are you sure want to block $userName right now ?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: MessagingColors.primaryText,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 28),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MessagingColors.primaryText,
                      side: const BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'No',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onBlock,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MessagingColors.darkRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
