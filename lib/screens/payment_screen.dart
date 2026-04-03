import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentScreen extends StatefulWidget {
  final String itemName;
  final double price;
  final String type;
  const PaymentScreen({super.key, required this.itemName, required this.price, required this.type});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _couponController = TextEditingController();
  final _gameIdController = TextEditingController();
  double discount = 0.0;
  bool isProcessing = false;

  void applyCoupon() {
    FocusScope.of(context).unfocus();
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'DREAM10') {
      setState(() => discount = widget.price * 0.10);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Coupon Applied! Saved ₹${discount.toStringAsFixed(0)}'), backgroundColor: CupertinoColors.activeGreen));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Coupon Code'), backgroundColor: CupertinoColors.destructiveRed));
    }
  }

  Future<void> processPayUPayment() async {
    if (_gameIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Game ID first'), backgroundColor: CupertinoColors.destructiveRed));
      return;
    }
    
    setState(() => isProcessing = true);
    await Future.delayed(const Duration(seconds: 2)); // Mock PayU Processing
    
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance.collection('orders').add({
        'user_id': user.uid,
        'item_name': widget.itemName,
        'type': widget.type,
        'game_id': _gameIdController.text.trim(),
        'amount_paid': widget.price - discount,
        'status': 'pending', // Waiting for admin to approve
        'created_at': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Payment Successful'),
            content: const Text('Your order is sent to the Admin. Track it in your Orders tab.'),
            actions: [CupertinoDialogAction(child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)), onPressed: () => Navigator.popUntil(ctx, (route) => route.isFirst))],
          ),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    if (mounted) setState(() => isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final finalPrice = widget.price - discount;

    return Scaffold(
      appBar: const CupertinoNavigationBar(middle: Text('Checkout', style: TextStyle(fontWeight: FontWeight.w600)), backgroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order Summary', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(widget.type, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text(widget.itemName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                ]),
                const Divider(height: 32, color: Colors.black12),
                CupertinoTextField(
                  controller: _gameIdController, placeholder: 'Enter Player Game ID', keyboardType: TextInputType.number,
                  padding: const EdgeInsets.all(16), prefix: const Padding(padding: EdgeInsets.only(left: 16), child: Icon(CupertinoIcons.person_solid, color: Colors.grey)),
                  decoration: BoxDecoration(color: const Color(0xFFF2F2F7), borderRadius: BorderRadius.circular(16)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
            child: Row(
              children: [
                Expanded(child: CupertinoTextField(controller: _couponController, placeholder: 'Have a coupon code?', padding: const EdgeInsets.all(16), decoration: const BoxDecoration(border: Border.none))),
                CupertinoButton(color: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 20), borderRadius: BorderRadius.circular(14), onPressed: applyCoupon, child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Total Payable', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
                  Text('₹${finalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                ]),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, height: 56,
                  child: CupertinoButton(
                    color: CupertinoColors.activeGreen, borderRadius: BorderRadius.circular(20),
                    onPressed: isProcessing ? null : processPayUPayment,
                    child: isProcessing ? const CupertinoActivityIndicator(color: Colors.white) : const Text('Pay with PayU Gateway', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
