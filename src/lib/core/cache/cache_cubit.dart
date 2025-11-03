import 'package:flutter_bloc/flutter_bloc.dart';

/// Cache values are loaded into memory in splash screen
/// because getting values is an async operation
class CacheCubit extends Cubit<Map<String, String>> {
  CacheCubit() : super({});

  void updateCacheValues(Map<String, String> data) {
    emit(data);
  }
}
