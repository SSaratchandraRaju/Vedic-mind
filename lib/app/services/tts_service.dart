import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

/// Text-to-Speech Service
/// Manages text-to-speech functionality for reading lesson content aloud
class TtsService extends GetxService {
  late FlutterTts _flutterTts;

  // Observable states
  final RxBool isPlaying = false.obs;
  final RxBool isPaused = false.obs;
  final RxDouble speechRate = 0.5.obs; // Normal speed
  final RxDouble pitch = 1.0.obs;
  final RxDouble volume = 1.0.obs;
  final RxString currentLanguage = 'en-US'.obs;

  // Current text being read
  String? _currentText;

  @override
  void onInit() {
    super.onInit();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    _flutterTts = FlutterTts();

    // Configure TTS
    await _flutterTts.setLanguage(currentLanguage.value);
    await _flutterTts.setSpeechRate(speechRate.value);
    await _flutterTts.setPitch(pitch.value);
    await _flutterTts.setVolume(volume.value);

    // Set up handlers
    _flutterTts.setStartHandler(() {
      isPlaying.value = true;
      isPaused.value = false;
    });

    _flutterTts.setCompletionHandler(() {
      isPlaying.value = false;
      isPaused.value = false;
      _currentText = null;
    });

    _flutterTts.setCancelHandler(() {
      isPlaying.value = false;
      isPaused.value = false;
      _currentText = null;
    });

    _flutterTts.setPauseHandler(() {
      isPaused.value = true;
    });

    _flutterTts.setContinueHandler(() {
      isPaused.value = false;
    });

    _flutterTts.setErrorHandler((message) {
      print('TTS Error: $message');
      isPlaying.value = false;
      isPaused.value = false;
    });
  }

  /// Speak the given text
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    try {
      _currentText = text;
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking text: $e');
      Get.snackbar(
        'Error',
        'Failed to read content aloud',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Pause the current speech
  Future<void> pause() async {
    try {
      await _flutterTts.pause();
      isPaused.value = true;
    } catch (e) {
      print('Error pausing TTS: $e');
    }
  }

  /// Resume paused speech
  Future<void> resume() async {
    try {
      // Note: Some platforms don't support resume, so we may need to restart
      // Check if the platform supports it
      if (isPaused.value && _currentText != null) {
        // Try to continue (iOS)
        try {
          await _flutterTts.speak(_currentText!);
        } catch (e) {
          print('Resume not supported, restarting: $e');
        }
      }
      isPaused.value = false;
    } catch (e) {
      print('Error resuming TTS: $e');
    }
  }

  /// Stop the current speech
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      isPlaying.value = false;
      isPaused.value = false;
      _currentText = null;
    } catch (e) {
      print('Error stopping TTS: $e');
    }
  }

  /// Toggle play/pause
  Future<void> togglePlayPause(String text) async {
    if (isPlaying.value && !isPaused.value) {
      await pause();
    } else if (isPaused.value) {
      await resume();
    } else {
      await speak(text);
    }
  }

  /// Set speech rate (0.0 to 1.0, where 0.5 is normal)
  Future<void> setSpeechRate(double rate) async {
    try {
      speechRate.value = rate.clamp(0.0, 1.0);
      await _flutterTts.setSpeechRate(speechRate.value);
    } catch (e) {
      print('Error setting speech rate: $e');
    }
  }

  /// Set pitch (0.5 to 2.0, where 1.0 is normal)
  Future<void> setPitch(double pitchValue) async {
    try {
      pitch.value = pitchValue.clamp(0.5, 2.0);
      await _flutterTts.setPitch(pitch.value);
    } catch (e) {
      print('Error setting pitch: $e');
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double vol) async {
    try {
      volume.value = vol.clamp(0.0, 1.0);
      await _flutterTts.setVolume(volume.value);
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  /// Get available languages
  Future<List<String>> getLanguages() async {
    try {
      final languages = await _flutterTts.getLanguages;
      return List<String>.from(languages);
    } catch (e) {
      print('Error getting languages: $e');
      return ['en-US'];
    }
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    try {
      currentLanguage.value = language;
      await _flutterTts.setLanguage(language);
    } catch (e) {
      print('Error setting language: $e');
    }
  }

  /// Get available voices
  Future<List<Map>> getVoices() async {
    try {
      final voices = await _flutterTts.getVoices;
      return List<Map>.from(voices);
    } catch (e) {
      print('Error getting voices: $e');
      return [];
    }
  }

  /// Set voice
  Future<void> setVoice(Map<String, String> voice) async {
    try {
      await _flutterTts.setVoice(voice);
    } catch (e) {
      print('Error setting voice: $e');
    }
  }

  @override
  void onClose() {
    stop();
    super.onClose();
  }
}
