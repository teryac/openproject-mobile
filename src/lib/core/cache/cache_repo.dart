import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheRepo {
  const CacheRepo();

  // Secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Save multiple key-value pairs securely
  Future<void> saveAll(Map<String, String?> data) async {
    for (final entry in data.entries) {
      await _storage.write(key: entry.key, value: entry.value);
    }
  }

  /// Save a value securely
  Future<void> saveData({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  /// Read all stored key-value pairs
  Future<Map<String, String>> getAll() async {
    return await _storage.readAll();
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
