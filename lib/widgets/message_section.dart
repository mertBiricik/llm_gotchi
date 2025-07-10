import 'package:flutter/material.dart';
import '../theme/retro_theme.dart';

class MessageSection extends StatefulWidget {
  const MessageSection({super.key});

  @override
  State<MessageSection> createState() => _MessageSectionState();
}

class _MessageSectionState extends State<MessageSection> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: RetroTheme.deepBlack,
        border: Border.all(color: RetroTheme.primaryGreen, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SEND MESSAGE TO PARTNER',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          
          // Message input field
          TextField(
            controller: _messageController,
            style: Theme.of(context).textTheme.bodySmall,
            decoration: InputDecoration(
              hintText: 'TYPE MESSAGE...',
              hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: RetroTheme.primaryGreen, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: RetroTheme.primaryGreen, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: RetroTheme.terminalAmber, width: 2),
              ),
            ),
            maxLines: 1,
          ),
          
          const SizedBox(height: 8),
          
          // Transmit button
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  _sendMessage(_messageController.text.trim());
                  _messageController.clear();
                }
              },
              style: RetroTheme.greenButtonStyle(),
              child: Text(
                'TRANSMIT',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    // Implement message sending logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'MESSAGE TRANSMITTED: $message',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: RetroTheme.deepBlack,
          ),
        ),
        backgroundColor: RetroTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 