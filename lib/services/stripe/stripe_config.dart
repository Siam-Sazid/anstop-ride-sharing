// Configuration class for Stripe settings
import 'package:flutter/material.dart';

class StripeConfig {
  final String secretKey;
  final String merchantDisplayName;
  final ThemeMode paymentSheetTheme;
  final bool allowsDelayedPaymentMethods;
  final String baseUrl;

  const StripeConfig({
    required this.secretKey,
    this.merchantDisplayName = 'Your Business Name',
    this.paymentSheetTheme = ThemeMode.system,
    this.allowsDelayedPaymentMethods = true,
    this.baseUrl = 'https://api.stripe.com/v1',
  });
}
