import 'package:flutter_bloc/flutter_bloc.dart';

class ViewWorkPackageScrollCubit extends Cubit<int> {
  ViewWorkPackageScrollCubit() : super(0);

  void updateIndex(int newIndex) {
    if (state != newIndex) emit(newIndex);
  }
}
