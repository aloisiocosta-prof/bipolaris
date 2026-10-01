import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense_entry.dart';

class ExpenseVault {
  ExpenseVault({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _storageKey = 'bipolaris.expense-vault.v1';
  static const _envelopeVersion = 1;
  static const _iterations = 600000;
  static final _cipher = AesGcm.with256bits();

  final SharedPreferencesAsync _preferences;

  Future<bool> exists() async =>
      await _preferences.getString(_storageKey) != null;

  Future<ExpenseVaultSession> create(String passphrase) async {
    final salt = _randomBytes(16);
    final key = await _deriveKey(passphrase, salt);
    final session = ExpenseVaultSession._(_preferences, salt, key);
    await session.save(const []);
    return session;
  }

  Future<VaultContents> unlock(String passphrase) async {
    final encoded = await _preferences.getString(_storageKey);
    if (encoded == null) throw const VaultUnlockException();
    try {
      final envelope = jsonDecode(encoded) as Map<String, dynamic>;
      if (envelope['version'] != _envelopeVersion ||
          envelope['algorithm'] != 'AES-256-GCM' ||
          envelope['kdf'] != 'PBKDF2-HMAC-SHA256' ||
          envelope['iterations'] != _iterations) {
        throw const VaultUnlockException();
      }
      final salt = base64Decode(envelope['salt'] as String);
      final key = await _deriveKey(passphrase, salt);
      final secretBox = SecretBox(
        base64Decode(envelope['cipherText'] as String),
        nonce: base64Decode(envelope['nonce'] as String),
        mac: Mac(base64Decode(envelope['mac'] as String)),
      );
      final plaintext = await _cipher.decrypt(secretBox, secretKey: key);
      final decoded = jsonDecode(utf8.decode(plaintext)) as List<dynamic>;
      final entries =
          decoded
              .map(
                (value) => ExpenseEntry.fromJson(
                  Map<String, Object?>.from(value as Map),
                ),
              )
              .toList()
            ..sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));
      return VaultContents(
        ExpenseVaultSession._(_preferences, salt, key),
        entries,
      );
    } on VaultUnlockException {
      rethrow;
    } catch (_) {
      throw const VaultUnlockException();
    }
  }

  static Future<SecretKey> _deriveKey(String passphrase, List<int> salt) =>
      Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: _iterations,
        bits: 256,
      ).deriveKey(secretKey: SecretKey(utf8.encode(passphrase)), nonce: salt);

  static List<int> _randomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(256));
  }
}

class VaultContents {
  const VaultContents(this.session, this.entries);

  final ExpenseVaultSession session;
  final List<ExpenseEntry> entries;
}

class ExpenseVaultSession {
  ExpenseVaultSession._(this._preferences, this._salt, this._key);

  final SharedPreferencesAsync _preferences;
  final List<int> _salt;
  final SecretKey _key;

  Future<void> save(List<ExpenseEntry> entries) async {
    final nonce = ExpenseVault._randomBytes(12);
    final plaintext = utf8.encode(
      jsonEncode(entries.map((entry) => entry.toJson()).toList()),
    );
    final box = await ExpenseVault._cipher.encrypt(
      plaintext,
      secretKey: _key,
      nonce: nonce,
    );
    final envelope = jsonEncode({
      'version': ExpenseVault._envelopeVersion,
      'algorithm': 'AES-256-GCM',
      'kdf': 'PBKDF2-HMAC-SHA256',
      'iterations': ExpenseVault._iterations,
      'salt': base64Encode(_salt),
      'nonce': base64Encode(box.nonce),
      'cipherText': base64Encode(box.cipherText),
      'mac': base64Encode(box.mac.bytes),
    });
    await _preferences.setString(ExpenseVault._storageKey, envelope);
  }

  Future<void> destroy() => _preferences.remove(ExpenseVault._storageKey);
}

class VaultUnlockException implements Exception {
  const VaultUnlockException();
}
