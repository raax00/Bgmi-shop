import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'payment_screen.dart';

class ShopScreen extends StatelessWidget {
  final String type;
  const ShopScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // Dummy Data - In production, fetch this from Firestore 'products' collection
    final List<Map<String, dynamic>> packages = type == 'UC' 
      ? [{'name': '60 UC', 'price': 75}, {'name': '380 UC', 'price': 380}, {'name': '660 UC', 'price': 750}]
      : [{'name': '10K Pts', 'price': 150}, {'name': '50K Pts', 'price': 700}];

    final color = type == 'UC' ? const Color(0xFF0097A7) : CupertinoColors.activeOrange;

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Buy $type', style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white.withOpacity(0.9),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final pkg = packages[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(pkg['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text('Premium $type Delivery', style: TextStyle(color: Colors.grey.shade500)),
              trailing: CupertinoButton(
                color: color, padding: const EdgeInsets.symmetric(horizontal: 20), borderRadius: BorderRadius.circular(16),
                child: Text('₹${pkg['price']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => PaymentScreen(itemName: pkg['name'], price: pkg['price'].toDouble(), type: type))),
              ),
            ),
          );
        },
      ),
    );
  }
}
