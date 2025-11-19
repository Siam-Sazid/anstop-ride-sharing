import 'package:flutter/material.dart';
import 'package:ride_sharing/widgets/custom_horizontal_line.dart';

import '../../../app/utils/app_colors.dart';


class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const SettingsMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: SettingsColors.iconColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: SettingsColors.primaryText,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: SettingsColors.secondaryText,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: CustomHorizontalLine(
              thickness: 1,
              color: AppColors.grayShade100,
            )
          ),
      ],
    );
  }
}
