import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: CupertinoNavigationBar(middle: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.w600)), backgroundColor: Colors.white.withOpacity(0.9)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').where('user_id', isEqualTo: uid).orderBy('created_at', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CupertinoActivityIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(CupertinoIcons.doc_text_search, size: 60, color: Colors.grey.shade400), const SizedBox(height: 16), const Text('No orders found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('Your purchases will appear here.', style: TextStyle(color: Colors.grey.shade500))]));
          }

          final orders = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final doc = orders[index];
              final status = doc['status'].toString().toLowerCase();
              final isCompleted = status == 'completed' || status == 'delivered';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(doc['item_name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        Text('₹${doc['amount_paid']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0097A7))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Game ID: ${doc['game_id']}', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: isCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(color: isCompleted ? CupertinoColors.activeGreen : CupertinoColors.activeOrange, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
