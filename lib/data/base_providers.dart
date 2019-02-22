import '../models/basemodel.dart';

abstract class SyncBaseProvider<T extends BaseModel>{
  Future<int> upsert(T item, {int is_dirty});
  Future<List<T>> getAllDirty();
  Future<bool> updateDirtyFlag(T guid);
}

abstract class SyncRestBaseProvider<T extends BaseModel>{
  Future<dynamic> upsert(Map<String,String> auth_headers, T newItem, int revision);
  Future<List<T>>getUpdatedItems({Map<String,String> auth_headers, int revision});
}