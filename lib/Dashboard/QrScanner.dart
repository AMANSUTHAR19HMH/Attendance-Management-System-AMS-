import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  String scannedUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: MobileScanner(
        allowDuplicates: false,
        onDetect: (barcode, args) {
          final String code = barcode.rawValue ?? '---';
          setState(() {
            scannedUrl = code;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Barcode found: $code')),
          );
        },
      ),
      bottomNavigationBar: scannedUrl.isNotEmpty
          ? BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Scanned URL: $scannedUrl',
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      )
          : null,
    );
  }
}
