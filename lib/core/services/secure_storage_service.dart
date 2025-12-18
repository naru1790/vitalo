import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Secure storage adapter for Supabase Auth tokens.
/// Uses the device's secure enclave (Keychain on iOS, custom ciphers on Android).
class SecureLocalStorage extends LocalStorage {
  SecureLocalStorage()
    : _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  final FlutterSecureStorage _storage;

  @override
  Future<void> initialize() async {
    // No initialization needed for flutter_secure_storage
  }

  @override
  Future<String?> accessToken() async {
    return await _storage.read(key: supabasePersistSessionKey);
  }

  @override
  Future<bool> hasAccessToken() async {
    final token = await _storage.read(key: supabasePersistSessionKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    await _storage.write(
      key: supabasePersistSessionKey,
      value: persistSessionString,
    );
  }

  @override
  Future<void> removePersistedSession() async {
    await _storage.delete(key: supabasePersistSessionKey);
  }
}
