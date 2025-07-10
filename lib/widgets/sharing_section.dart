import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/pet_service.dart';

class SharingSection extends StatefulWidget {
  final PetService petService;

  const SharingSection({
    super.key,
    required this.petService,
  });

  @override
  State<SharingSection> createState() => _SharingSectionState();
}

class _SharingSectionState extends State<SharingSection> {
  final TextEditingController _importController = TextEditingController();
  bool _showImportField = false;
  String _lastMessage = '';
  Color _messageColor = Colors.green;

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  void _showMessage(String message, Color color) {
    setState(() {
      _lastMessage = message;
      _messageColor = color;
    });
    
    // Clear message after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _lastMessage = '';
        });
      }
    });
  }

  void _exportPetData() async {
    try {
      final data = widget.petService.exportPetData();
      await Clipboard.setData(ClipboardData(text: data));
      _showMessage('Pet data copied to clipboard! Share with your partner.', Colors.green);
    } catch (e) {
      _showMessage('Failed to export pet data.', Colors.red);
    }
  }

  void _importPetData() async {
    final data = _importController.text.trim();
    if (data.isEmpty) {
      _showMessage('Please paste the pet data first.', Colors.orange);
      return;
    }

    final success = widget.petService.importPetData(data);
    if (success) {
      _showMessage('Pet data imported successfully!', Colors.green);
      _importController.clear();
      setState(() {
        _showImportField = false;
      });
    } else {
      _showMessage('Invalid pet data. Please check and try again.', Colors.red);
    }
  }

  void _pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData('text/plain');
      if (clipboardData?.text != null) {
        _importController.text = clipboardData!.text!;
      }
    } catch (e) {
      _showMessage('Failed to access clipboard.', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.share,
                color: Colors.blue,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Share with Partner',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          // Description
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Export your pet data to share progress with your partner, or import their data to sync up!',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _exportPetData,
                  icon: const Icon(Icons.upload, size: 20),
                  label: const Text('Export Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ).animate()
                  .slideX(begin: -0.3, duration: 600.ms, curve: Curves.easeOut)
                  .fadeIn(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showImportField = !_showImportField;
                      if (!_showImportField) {
                        _importController.clear();
                      }
                    });
                  },
                  icon: Icon(_showImportField ? Icons.close : Icons.download, size: 20),
                  label: Text(_showImportField ? 'Cancel' : 'Import Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showImportField ? Colors.grey : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ).animate()
                  .slideX(begin: 0.3, duration: 600.ms, curve: Curves.easeOut)
                  .fadeIn(),
              ),
            ],
          ),
          
          // Import field
          if (_showImportField) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Import Pet Data',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _pasteFromClipboard,
                        icon: const Icon(Icons.content_paste, size: 16),
                        label: const Text('Paste'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _importController,
                    decoration: InputDecoration(
                      hintText: 'Paste your partner\'s pet data here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _importPetData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Import Pet Data'),
                    ),
                  ),
                ],
              ),
            ).animate()
              .slideY(begin: -0.3, duration: 400.ms, curve: Curves.easeOut)
              .fadeIn(duration: 300.ms),
          ],
          
          // Message display
          if (_lastMessage.isNotEmpty) ...[
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _messageColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _messageColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    _messageColor == Colors.green
                        ? Icons.check_circle_outline
                        : _messageColor == Colors.orange
                            ? Icons.warning_amber_outlined
                            : Icons.error_outline,
                    color: _messageColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _lastMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: _messageColor.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate()
              .slideY(begin: 0.3, duration: 300.ms, curve: Curves.easeOut)
              .fadeIn(duration: 200.ms),
          ],
        ],
      ),
    );
  }
} 