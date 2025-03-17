import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

class Tools {
  /// 检测语言类型
  static Future<String> identifyLanguage(String text) async {
    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
    final String response = await languageIdentifier.identifyLanguage(text);
    languageIdentifier.close();
    return response;
  }
}
