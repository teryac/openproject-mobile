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
    final safeArea = EdgeInsets.only(
      top: MediaQuery.paddingOf(context).top,
      bottom: MediaQuery.paddingOf(context).bottom,
      right: MediaQuery.paddingOf(context).right,
      left: MediaQuery.paddingOf(context).left,
    );
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
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    AuthScreenViewSwitch(safeArea: safeArea),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: SafeArea(
                child: AuthScreenHeader(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
