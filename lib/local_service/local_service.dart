import 'dart:convert';
import 'dart:developer';

import 'package:cnb_local_database/encryptions/encryption_service.dart';
import 'package:cnb_local_database/local_service/abs_local_service.dart';
import 'package:cnb_local_database/utils/source_key.dart';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class HiveCNBLocalService extends IHiveLocalService {
  static HiveCNBLocalService? _instance;
  HiveCNBLocalService._();

  factory HiveCNBLocalService() {
    _instance ??= HiveCNBLocalService._();
    return _instance!;
  }

  late Box _localCNBAppBox;
  Box get localCNBApptBox => _localCNBAppBox;

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
    _localCNBAppBox = await Hive.openBox(hiveBoxFieldName.toString(),
        encryptionCipher: HiveAesCipher(key));
    EncryptionService().init(SourceKey.PRIVATE_KEY);
  }

  @override
  Future<void> clearCNBHiveBox(String hiveBoxFieldName) async {
    await _getInstance(hiveBoxFieldName);
    await _clearBox(_localCNBAppBox);
  }

  @override
  Future<void> deleteCNBHiveBoxAt(String hiveBoxFieldName, int index) async {
    await _getInstance(hiveBoxFieldName);
    await _deleteBoxValueAt(_localCNBAppBox, index);
  }

  @override
  Future<List<dynamic>> retrieveCNBHiveBox(String hiveBoxFieldName) async {
    try {
      await _getInstance(hiveBoxFieldName);
      List<dynamic> dataHiveBox = [];
      for (var list in await _getAllBoxValues(localCNBApptBox)) {
        final decrypt = EncryptionService().decryptData(list);
        dataHiveBox.add(decrypt);
      }
      return dataHiveBox;
    } catch (e, stackTrace) {
      log('RetrievCNBHiveBox-Exception: $e');
      log('RetrievCNBHiveBox-StackTrace: $stackTrace');
      return [];
    }
  }

  @override
  Future<void> saveCNBHiveBox(String hiveBoxFieldName, dynamic value) async {
    try {
      await _getInstance(hiveBoxFieldName);
      var encrypt = EncryptionService().encryptData(value);
      await _localCNBAppBox.add(encrypt);
    } catch (e, stackTrace) {
      log('SaveCNBHiveBox-Exception: $e');
      log('SaveCNBHiveBox-StackTrace: $stackTrace');
    }
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
