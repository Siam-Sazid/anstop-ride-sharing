import 'package:flutter/material.dart';
import 'package:ride_sharing/feature/passenger/wallet/view/passenger_wallet_dialog_view.dart';
import 'package:ride_sharing/utils/balanced_card.dart';
import 'package:ride_sharing/utils/transaction_items.dart';
import 'package:ride_sharing/widgets/custom_app_bar_title.dart';
import '../../../../app/utils/app_colors.dart';


class PassengerWalletPage extends StatefulWidget {
  const PassengerWalletPage({Key? key}) : super(key: key);

  @override
  State<PassengerWalletPage> createState() => _PassengerWalletPageState();
}

class _PassengerWalletPageState extends State<PassengerWalletPage> {
  void _showWithdrawDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => WithdrawDialog(
        onConfirm: () {
          Navigator.pop(context);
          _showSuccessDialog();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => WithdrawSuccessDialog(
        onGoToWallet: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
     // appBar:  CustomAppBarTitle(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Balance Card
            BalanceCard(
              balance: '2652',
              onWithdraw: _showWithdrawDialog,
              onDeposit: () {},
            ),

            const SizedBox(height: 32),

            // Transactions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Transaction List
                  const TransactionItem(
                    title: 'Welton',
                    time: 'Today at 09:20 am',
                    amount: '570.00',
                    isPositive: false,
                  ),
                  const TransactionItem(
                    title: 'Add in Wallet',
                    time: 'Today at 09:20 am',
                    amount: '570.00',
                    isPositive: true,
                  ),
                  const TransactionItem(
                    title: 'Welton',
                    time: 'Today at 09:20 am',
                    amount: '570.00',
                    isPositive: false,
                  ),
                  const TransactionItem(
                    title: 'Add in Wallet',
                    time: 'Today at 09:20 am',
                    amount: '570.00',
                    isPositive: true,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}