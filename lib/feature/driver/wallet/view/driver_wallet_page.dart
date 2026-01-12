import 'package:flutter/material.dart';
import 'package:ride_sharing/feature/passenger/wallet/view/passenger_wallet_dialog_view.dart';
import 'package:ride_sharing/utils/balanced_card.dart';
import 'package:ride_sharing/utils/transaction_items.dart';
import 'package:ride_sharing/widgets/custom_app_bar_title.dart';
import '../../../../app/utils/app_colors.dart';
import '../../../../l10n/l10n_helper.dart';


class DriverWalletPage extends StatefulWidget {
  const DriverWalletPage({Key? key}) : super(key: key);

  @override
  State<DriverWalletPage> createState() => _DriverWalletPageState();
}

class _DriverWalletPageState extends State<DriverWalletPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


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
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBarTitle(
      scaffoldKey: _scaffoldKey,
      title: AppLocalization.tr.walletTitle,
      titleColor: AppColors.blackShade300,
    ),
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
                  TransactionItem(
                    title: AppLocalization.tr.transactionNameExample1,
                    time: 'Today at 09:20 am',
                    amount: '570.00',
                    isPositive: false,
                  ),
                  TransactionItem(
                    title: AppLocalization.tr.transactionTypeExample,
                    time: 'Today at 09:20 am',
                    amount: '570.00',
                    isPositive: true,
                  ),
                  TransactionItem(
                    title: AppLocalization.tr.transactionNameExample1,
                    time: 'Today at 09:20 am',
                    amount: '570.00',
                    isPositive: false,
                  ),
                  TransactionItem(
                    title: AppLocalization.tr.transactionTypeExample,
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