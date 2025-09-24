import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final baseUrlProvider = StateNotifierProvider<BaseUrlNotifier, String?>((ref) {
  return BaseUrlNotifier();
});

class BaseUrlNotifier extends StateNotifier<String?> {
  BaseUrlNotifier() : super(null) {
    _loadBaseUrl();
  }

  static const String _baseUrlKey = 'dynamic_base_url';

  Future<void> _loadBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_baseUrlKey);
  }

  Future<void> setBaseUrl(String baseUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, baseUrl);
    state = baseUrl;
  }

  Future<void> clearBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_baseUrlKey);
    state = null;
  }
}
