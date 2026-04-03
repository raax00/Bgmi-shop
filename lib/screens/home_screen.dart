import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'shop_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            const Text('Store', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1)),
            Text('Premium Gaming Services', style: TextStyle(fontSize: 16, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
            const SizedBox(height: 32),
            
            // UC Card
            _buildBigCard(
              context,
              title: 'BGMI UC',
              subtitle: 'Instant Top-up directly to ID',
              icon: CupertinoIcons.money_dollar_circle_fill,
              color: const Color(0xFF0097A7),
              onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const ShopScreen(type: 'UC'))),
            ),
            const SizedBox(height: 20),
            
            // Popularity Card
            _buildBigCard(
              context,
              title: 'Popularity',
              subtitle: 'Boost your BGMI ranking',
              icon: CupertinoIcons.flame_fill,
              color: CupertinoColors.activeOrange,
              onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const ShopScreen(type: 'Popularity'))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Icon(icon, color: color, size: 36),
            ),
            const Spacer(),
            Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
            const SizedBox(height: 6),
            Text(subtitle, style: TextStyle(fontSize: 15, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
