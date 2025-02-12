abstract class IHiveLocalService {
  Future<void> saveCNBHiveBox(String hiveBoxFieldName, dynamic value);
  Future<List<dynamic>> retrieveCNBHiveBox(String hiveBoxFieldName);
  Future<void> clearCNBHiveBox(String hiveBoxFieldName);
  Future<void> deleteCNBHiveBoxAt(String hiveBoxFieldName, int index);
}
