import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(middle: const Text('Live Support'), backgroundColor: Colors.white.withOpacity(0.9)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: CupertinoColors.activeBlue.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(CupertinoIcons.chat_bubble_2_fill, size: 60, color: CupertinoColors.activeBlue)),
            const SizedBox(height: 24),
            const Text('Live Chat Support', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Our agents will be online soon.\nFor immediate help, contact Admin via WhatsApp.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
