import 'package:flutter/material.dart';

class ErrorDialog {
  static bool _isDialogOpen = false;
  
  static void showErrorDialog(BuildContext context, String errorMessage) {
    if (_isDialogOpen) return; 
    _isDialogOpen = true;

    Future.microtask(() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'ERROR',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning, color: Colors.red, size: 40),
              SizedBox(height: 10),
              Text(
                errorMessage,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
                _isDialogOpen = false; 
              },
              child: Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ).then((_) {

        _isDialogOpen = false;
      });
    });
  }
}
