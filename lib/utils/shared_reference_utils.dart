/*
*
* @author Syed Bipul Rahman
* @Support: https://github.com/Syed-Bipul-Rahman
* All rights reserved
*
*/

import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

class SharedPreferencesUtil {
  static final Logger _logger = Logger('SharedPreferencesUtil');
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _logger.info('SharedPreferences initialized');
  }

  // String operations
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
    _logger.info('$key, SUCCESSFULLY SET TO SHARED PREFS');
  }

  String getString(String key, {String defaultValue = ""}) {
    final value = _prefs.getString(key) ?? defaultValue;
    _logger.info('$key, SUCCESSFULLY GET FROM SHARED PREFS');
    return value;
  }

  // Bool operations
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
    _logger.info('$key, SUCCESSFULLY SET TO SHARED PREFS');
  }

  bool getBool(String key, {bool defaultValue = false}) {
    final value = _prefs.getBool(key) ?? defaultValue;
    _logger.info('$key, SUCCESSFULLY GET FROM SHARED PREFS');
    return value;
  }

  // Int operations
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
    _logger.info('$key, SUCCESSFULLY SET TO SHARED PREFS');
  }

  int getInt(String key, {int defaultValue = -1}) {
    final value = _prefs.getInt(key) ?? defaultValue;
    _logger.info('$key, SUCCESSFULLY GET FROM SHARED PREFS');
    return value;
  }

  // Double operations
  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
    _logger.info('$key, SUCCESSFULLY SET TO SHARED PREFS');
  }

  double? getDouble(String key) {
    final value = _prefs.getDouble(key);
    _logger.info('$key, SUCCESSFULLY GET FROM SHARED PREFS');
    return value;
  }

  // Remove operation
  Future<void> remove(String key) async {
    await _prefs.remove(key);
    _logger.warning('$key, SUCCESSFULLY REMOVED FROM SHARED PREFS');
  }

  // Clear all preferences
  Future<void> clear() async {
    await _prefs.clear();
    _logger.warning('ALL PREFERENCES CLEARED');
  }

  // Check if key exists
  bool containsKey(String key) {
    final exists = _prefs.containsKey(key);
    _logger.info('$key exists in SharedPreferences: $exists');
    return exists;
  }

  // Get all keys
  Set<String> getKeys() {
    final keys = _prefs.getKeys();
    _logger.info(
      'Retrieved all keys from SharedPreferences: ${keys.length} keys',
    );
    return keys;
  }

  // User role operations
  static const String _userRoleKey = 'user_role';

  Future<void> setUserRole(String role) async {
    await setString(_userRoleKey, role);
    _logger.info('User role set to: $role');
  }

  String? getUserRole() {
    if (!containsKey(_userRoleKey)) {
      _logger.warning('User role not found in SharedPreferences');
      return null;
    }
    final role = getString(_userRoleKey);
    _logger.info('User role retrieved: $role');
    return role;
  }

  Future<void> clearUserRole() async {
    await remove(_userRoleKey);
    _logger.info('User role cleared from SharedPreferences');
  }
}
