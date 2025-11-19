
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_sharing/feature/messages/view/report_description_screen.dart';
import '../../../app/utils/app_colors.dart';


class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedReason;

  final List<String> reportReasons = [
    'Hate Speech',
    'Threat',
    'Harassment',
    'Pretending to be something',
    'Fraud Or Scam',
    'Fake Identity',
    'Something Else',
    'Other',
  ];

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

                    // Radio Button List
                    ...reportReasons.map((reason) {
                      return _buildRadioOption(reason);
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),

          // Continue Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedReason != null
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportDescriptionScreen(
                        selectedReason: selectedReason!,
                      ),
                    ),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MessagingColors.primaryGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: MessagingColors.primaryGreen.withOpacity(0.5),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Continue',
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

  Widget _buildRadioOption(String reason) {
    final isSelected = selectedReason == reason;

    return InkWell(
      onTap: () {
        setState(() {
          selectedReason = reason;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? MessagingColors.radioSelected
                      : MessagingColors.radioUnselected,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: MessagingColors.radioSelected,
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              reason,
              style: TextStyle(
                fontSize: 15,
                color: isSelected
                    ? MessagingColors.primaryText
                    : MessagingColors.secondaryText,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
