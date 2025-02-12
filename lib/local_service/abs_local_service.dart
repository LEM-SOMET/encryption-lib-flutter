abstract class IHiveLocalService {
  Future<void> saveHiveBox(String hiveBoxFieldName, dynamic value);
  Future<List<dynamic>> retrieveHiveBox(String hiveBoxFieldName);
  Future<void> clearHiveBox(String hiveBoxFieldName);
  Future<void> deleteHiveBoxAt(String hiveBoxFieldName, int index);
}
