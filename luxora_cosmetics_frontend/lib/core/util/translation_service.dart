import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  late Map<String, dynamic> _localizedStrings;

  factory TranslationService() {
    return _instance;
  }

  TranslationService._internal();

  static Future<TranslationService> load(String languageCode) async {
    final localizationService = TranslationService._internal();
    String filePath = 'assets/translations/$languageCode.json';
    if (kDebugMode) {
      print("File Path: $filePath");
    }

    try {
      String jsonContent = await rootBundle.loadString(filePath);

      localizationService._localizedStrings =
          Map<String, dynamic>.from(json.decode(jsonContent));
    } catch (e) {
      if (kDebugMode) {
        print("Error loading JSON: $e");
      }
    }

    return localizationService;
  }

  String translate(String key) {
    // For nested keys, you can split them and navigate through the structure
    List<String> keyParts = key.split('.');
    dynamic current = _localizedStrings;

    for (var part in keyParts) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        // If the key is not found, return the key itself
        return key;
      }
    }

    // Return the final translation or the key itself if not found
    return current ?? key;
  }
}
