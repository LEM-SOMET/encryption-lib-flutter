import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class HiveLocalServiceNonEncryption {
  static HiveLocalServiceNonEncryption? _instance;
  HiveLocalServiceNonEncryption._();

  factory HiveLocalServiceNonEncryption() {
    _instance ??= HiveLocalServiceNonEncryption._();
    return _instance!;
  }

  late Box _localAppBox;
  Box get localApptBox => _localAppBox;

  _getInstance(String hiveBoxFieldName) async {
    final directory = await getApplicationDocumentsDirectory();
    const storage = FlutterSecureStorage();
    String? encryptKey = await storage.read(key: "key");
    if (encryptKey == null) {
      var key1 = Hive.generateSecureKey();
      await storage.write(key: "key", value: base64.encode(key1));
      encryptKey = await storage.read(key: "key");
    }
    List<int> key = base64.decode(encryptKey!);
    Hive.init(directory.path);
    _localAppBox = await Hive.openBox(hiveBoxFieldName.toString(),
        encryptionCipher: HiveAesCipher(key));
  }

  Future<void> saveCNBHiveBox(String hiveBoxFieldName, dynamic value) async {
    try {
      await _getInstance(hiveBoxFieldName);
      await _localAppBox.add(value);
    } catch (e, stackTrace) {
      log('SaveCNBHiveBox-Exception: $e');
      log('SaveCNBHiveBox-StackTrace: $stackTrace');
    }
  }

  Future<List<dynamic>> retrievCNBHiveBox(String hiveBoxFieldName) async {
    try {
      await _getInstance(hiveBoxFieldName);
      return _getAllBoxValues(localApptBox);
    } catch (e, stackTrace) {
      log('RetrievCNBHiveBox-Exception: $e');
      log('RetrievCNBHiveBox-StackTrace: $stackTrace');
      return [];
    }
  }

  Future<void> clearCNBHiveBox(String hiveBoxFieldName) async {
    await _getInstance(hiveBoxFieldName);
    await _clearBox(_localAppBox);
  }

  Future<void> deleteCNBHiveBoxAt(String hiveBoxFieldName, int index) async {
    await _getInstance(hiveBoxFieldName);
    await _deleteBoxValueAt(_localAppBox, index);
  }

  _getAllBoxValues(Box? box) {
    return box!.values.toList();
  }

  _deleteBoxValueAt(Box? box, int index) async {
    await box!.deleteAt(index);
  }

  _clearBox(Box? box) async {
    await box?.clear();
  }
}
