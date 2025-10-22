import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheHelper {
  const CacheHelper();

  // Secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Save a value securely
  Future<void> saveData({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  /// Save multiple key-value pairs securely
  Future<void> saveAll(Map<String, String?> data) async {
    for (final entry in data.entries) {
      await _storage.write(key: entry.key, value: entry.value);
    }
  }

  /// Read a value
  Future<String?> getData(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a single key
  Future<void> removeData(String key) async {
    await _storage.delete(key: key);
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if a key exists
  Future<bool> contains(String key) async {
    final all = await _storage.readAll();
    return all.containsKey(key);
  }
}
