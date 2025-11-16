import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/models/work_package_payload.dart';

class WorkPackagePayloadCubit extends Cubit<WorkPackagePayload?> {
  WorkPackagePayloadCubit() : super(null);

  void updatePayload(WorkPackagePayload payload) {
    emit(payload);
  }
}
