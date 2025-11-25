import 'package:flutter_bloc/flutter_bloc.dart';

/// In-memory cache
class CacheCubit extends Cubit<Map<String, String>> {
  CacheCubit() : super({});

  void updateCacheValues(Map<String, String> data) {
    emit(data);
  }

  void addCacheValue(String key, String value) {
    final newData = <String, String>{}..addAll(state);
    newData[key] = value;

    emit(newData);
  }
}
