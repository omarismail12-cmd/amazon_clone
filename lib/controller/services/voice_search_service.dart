import 'dart:developer';

import 'package:amazon/constants/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Thin wrapper around speech_to_text shared by every mic icon in the app
/// (home, category browsing, search). Handles permission/availability
/// failures with a toast instead of letting them surface as exceptions.
class VoiceSearchService {
  static final stt.SpeechToText _speech = stt.SpeechToText();

  static Future<void> listen({
    required BuildContext context,
    required void Function(String recognizedText) onResult,
  }) async {
    final bool available = await _speech.initialize(
      onError: (error) => log('speech_to_text error: ${error.errorMsg}'),
      onStatus: (status) => log('speech_to_text status: $status'),
    );
    if (!available) {
      if (!context.mounted) return;
      CommonFunctions.showErrorToast(
        context: context,
        message:
            'Voice search needs microphone access. Please allow it in your device settings.',
      );
      return;
    }
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
          onResult(result.recognizedWords.trim());
        }
      },
    );
  }
}
