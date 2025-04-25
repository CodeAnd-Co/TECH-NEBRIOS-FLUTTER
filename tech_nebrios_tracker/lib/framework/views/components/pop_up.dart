import 'package:flutter/material.dart';

class Popup {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Aceptar',
    VoidCallback? onConfirm,
  }) {
    
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
  }
}
