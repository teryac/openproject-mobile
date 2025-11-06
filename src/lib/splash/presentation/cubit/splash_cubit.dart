import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/cache/cache_repo.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final CacheRepo _cacheRepo;
  SplashCubit({
    required CacheRepo cacheHelper,
  })  : _cacheRepo = cacheHelper,
        super(SplashInitialState()) {
    loadData();
  }

  void loadData() async {
    // These declare a future, but don't run it
    final delayFuture = Future.delayed(
      const Duration(milliseconds: 2000),
    );
    final preloadCacheFuture = _cacheRepo.getAll();

    // Load everything at once
    try {
      final result = await Future.wait([
        delayFuture,
        preloadCacheFuture,
      ]);

      // When this state is catched, the `CacheCubit` will be
      // updated with the data provided from this state
      emit(SplashCacheLoadedState(data: result[1]));

      // Finally, emit completed state, after this the splash
      // screen is closed
      emit(SplashOperationsCompletedState());
    } catch (excpetion) {
      // If an exception in getting the cache happens, clear all cache,
      // and emit a failure state
      _cacheRepo.clearAll();
      emit(SplashCacheLoadingFailedState());
    }
  }
}
