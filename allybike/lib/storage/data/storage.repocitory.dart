import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IStorageRepository)
class StorageRepository implements IStorageRepository {
  final FlutterSecureStorage _storage;

  StorageRepository({required FlutterSecureStorage storage}) : _storage = storage;

  @override
  Future<void> write({required String key, required String value}) async {
    return _storage.write(key: key, value: value);
  }
  
  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }
  
  @override
  Future<void> deleteAll() {
    return _storage.deleteAll();
  }

   
   
}

abstract class IStorageRepository {
   Future<void> write({required String key, required String value});
   Future<String?> read({required String key});
   Future<void> deleteAll();
}