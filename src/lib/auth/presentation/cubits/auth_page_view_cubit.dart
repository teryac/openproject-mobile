import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPageViewCubit extends Cubit<int> {
  AuthPageViewCubit() : super(0);

  void changePage(int index) {
    emit(index);
  }
}
