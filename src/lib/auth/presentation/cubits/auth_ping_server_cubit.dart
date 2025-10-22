import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/auth/data/auth_repo.dart';
import 'package:open_project/core/util/failure.dart';

class AuthPingServerCubit extends Cubit<AsyncValue<void, NetworkFailure>> {
  final AuthRepo _authRepo;
  AuthPingServerCubit({required AuthRepo authRepo})
      : _authRepo = authRepo,
        // Default value is nothing, neither loading,
        // nor data, nor failure.
        // Because the user hasn't pinged yet
        super(const AsyncValue.initial());

  Future<void> pingServer(String serverURL) async {
    // If already requested, skip.
    if (state.isLoading) return;

    emit(const AsyncValue.loading());

    final result = await _authRepo.pingServer(serverURL);

    if (result.isData) {
      // Emitted `null` data, because the return type
      // is `void`, and `void` can't be used like that,
      // so `null` is used instead.
      emit(const AsyncValue.data(data: null));
    } else {
      // `result.error` is never null in this `else` statement
      // because the result is either `isData` or `isError`
      emit(AsyncValue.error(error: result.error!));
    }
  }

  /// This function is used when the user goes back from the
  /// token input screen to allow him to type a new server url
  void resetState() {
    emit(const AsyncValue.initial());
  }
}
