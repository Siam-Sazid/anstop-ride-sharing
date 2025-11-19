import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/utils/app_colors.dart';


class ReportDescriptionScreen extends StatefulWidget {
  final String selectedReason;

  const ReportDescriptionScreen({
    Key? key,
    required this.selectedReason,
  }) : super(key: key);

  @override
  State<ReportDescriptionScreen> createState() =>
      _ReportDescriptionScreenState();
}

class _ReportDescriptionScreenState extends State<ReportDescriptionScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: MessagingColors.primaryText,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report',
          style: TextStyle(
            color: MessagingColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Find Support or Report User',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MessagingColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Help us understanding what\'s happening',
                      style: TextStyle(
                        fontSize: 14,
                        color: MessagingColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Selected Reason Display
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: MessagingColors.radioSelected,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: MessagingColors.radioSelected,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          widget.selectedReason,
                          style: const TextStyle(
                            fontSize: 15,
                            color: MessagingColors.primaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Description Section
                    const Text(
                      'Describe your Complain',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MessagingColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Hate speech involves harmful communication that originates hate (sex, religion, or gender). It harms diverse discrimination, and violence. Combating hate speech requires a balance between free expression and public safety.',
                      style: TextStyle(
                        fontSize: 13,
                        color: MessagingColors.secondaryText,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Submit Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit
                  _showSuccessDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MessagingColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: MessagingColors.primaryGreen,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Report Submitted',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: MessagingColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Thank you for your report. We will review it shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: MessagingColors.secondaryText,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MessagingColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
