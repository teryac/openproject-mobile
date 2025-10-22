import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/auth/data/auth_repo.dart';
import 'package:open_project/auth/models/user.dart';
import 'package:open_project/core/util/failure.dart';

class AuthGetUserCubit extends Cubit<AsyncValue<User, NetworkFailure>> {
  final AuthRepo _authRepo;
  AuthGetUserCubit({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(const AsyncValue.initial());

  Future<void> getUserData({
    required String serverUrl,
    required String apiToken,
  }) async {
    // If already requested, skip.
    if (state.isLoading) return;

    emit(const AsyncValue.loading());

    final result = await _authRepo.getUser(
      serverUrl: serverUrl,
      apiToken: apiToken,
    );

    if (result.isData) {
      emit(AsyncValue.data(data: result.data!));
    } else {
      emit(AsyncValue.error(error: result.error!));
    }
  }
}
