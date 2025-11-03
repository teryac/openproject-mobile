// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'splash_cubit.dart';

sealed class SplashState {}

class SplashInitialState extends SplashState {}

class SplashCacheLoadedState extends SplashState {
  final Map<String, String> data;
  SplashCacheLoadedState({required this.data});
}

class SplashCacheLoadingFailedState extends SplashState {}

class SplashOperationsCompletedState extends SplashState {}
