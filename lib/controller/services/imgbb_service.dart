import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ImgBBService {
  static const String _apiKey = '33bbcbb19588523dde371346e9d03074';

  /// ImgBB's free-tier API rejects uploads over 32MB; we cap well below that
  /// so oversized photos fail fast with a clear message instead of sitting
  /// through a long upload attempt that fails anyway.
  static const int maxImageSizeBytes = 10 * 1024 * 1024;

  /// Uploads image bytes to ImgBB and returns the public display URL,
  /// or null if the upload fails. Works on web, Android, and iOS since it
  /// operates on raw bytes rather than a dart:io File (which isn't
  /// available on web).
  static Future<String?> uploadImageBytes(Uint8List imageBytes) async {
    try {
      final uri = Uri.parse('https://api.imgbb.com/1/upload');
      final base64Image = base64Encode(imageBytes);

      final response = await http.post(
        uri,
        body: {
          'key': _apiKey,
          'image': base64Image,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data']['url'] as String?;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
