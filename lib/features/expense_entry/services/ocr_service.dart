import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../../core/models/expense.dart';

final ocrServiceProvider = Provider((ref) => OCRService());

class OCRResult {
  final double? amount;
  final String? merchantName;
  final String rawText;

  OCRResult({this.amount, this.merchantName, required this.rawText});
}

class OCRService {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<OCRResult> processImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizedText = await textRecognizer.processImage(inputImage);

    double? extractedAmount;
    String? extractedMerchant;

    // Simple heuristic for extraction
    final lines = recognizedText.text.split('\n');

    // 1. Try to find merchant name (usually first or second line)
    if (lines.isNotEmpty) {
      extractedMerchant = lines.first.trim();
    }

    // 2. Try to find amount (look for numbers with decimals, optionally preceded by $)
    final amountRegex = RegExp(r'\$?\s*(\d+\.\d{2})');
    for (final line in lines.reversed) {
      final match = amountRegex.firstMatch(line);
      if (match != null && match.groupCount >= 1) {
        extractedAmount = double.tryParse(match.group(1)!);
        if (extractedAmount != null) {
          break; // Found the total (usually at the bottom)
        }
      }
    }

    return OCRResult(
      amount: extractedAmount,
      merchantName: extractedMerchant,
      rawText: recognizedText.text,
    );
  }

  ExpenseCategory suggestCategory(String merchantName) {
    final lowerName = merchantName.toLowerCase();
    if (lowerName.contains('starbucks') ||
        lowerName.contains('mcdonalds') ||
        lowerName.contains('cafe')) {
      return ExpenseCategory.dining;
    } else if (lowerName.contains('apple') || lowerName.contains('best buy')) {
      return ExpenseCategory.electronics;
    } else if (lowerName.contains('uber') ||
        lowerName.contains('lyft') ||
        lowerName.contains('shell')) {
      return ExpenseCategory.transport;
    } else if (lowerName.contains('whole foods') ||
        lowerName.contains('walmart')) {
      return ExpenseCategory.groceries;
    }
    return ExpenseCategory.other;
  }

  void dispose() {
    textRecognizer.close();
  }
}
