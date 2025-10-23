import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/auth/models/user.dart';
import 'package:open_project/auth/presentation/cubits/auth_get_user_cubit.dart';
import 'package:open_project/auth/presentation/cubits/auth_ping_server_cubit.dart';
import 'package:open_project/auth/presentation/widgets/auth_screen_header.dart';
import 'package:open_project/auth/presentation/widgets/auth_screen_view_switch.dart';
import 'package:open_project/core/util/app_snackbar.dart';
import 'package:open_project/core/util/failure.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      // Show error dialogs, snackbars, and other
      // notifications here
      listeners: [
        BlocListener<AuthPingServerCubit, AsyncValue<void, NetworkFailure>>(
          listener: (context, state) {
            if (state.isError) {
              showErrorSnackBar(context, state.error!.errorMessage);
            }
          },
        ),
        BlocListener<AuthGetUserCubit, AsyncValue<User, NetworkFailure>>(
          listener: (context, state) {
            if (state.isError) {
              showErrorSnackBar(context, state.error!.errorMessage);
            }
          },
        ),
      ],
      child: const Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                AuthScreenHeader(),
                SizedBox(height: 20),
                AuthScreenViewSwitch(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
