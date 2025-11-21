import 'dart:math';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/auth/application/auth_controller.dart';
import 'package:open_project/auth/presentation/screens/server_input_screen.dart';
import 'package:open_project/auth/presentation/screens/token_input_screen.dart';

class AuthScreenViewSwitch extends StatelessWidget {
  const AuthScreenViewSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ExpandablePageView(
          physics: const NeverScrollableScrollPhysics(),
          controller:
              context.read<AuthController>().authScreenPageViewController,
          children: List.generate(
            2,
            (index) {
              final widgetMinHeight = MediaQuery.sizeOf(context).height -
                  MediaQuery.paddingOf(context).top -
                  MediaQuery.paddingOf(context).bottom -
                  124;

              return ConstrainedBox(
                constraints: BoxConstraints(
                  // For the previewed widget, set a minimum height of
                  // the screen size without the safe area padding, and
                  // without an approximate height of the pageview
                  // indicator widget at the top, and some extra space
                  // because `ServerInputScreen` and `TokenInputScreen`
                  // both contain a spacer widget, and a spacer widget
                  // needs a finite height, therefore some extra space
                  // is needed to see its effect in app.

                  // The max function is for safety, just in case
                  // `widgetMinHeight` goes below zero, which means the
                  // screen size is less than the pageview indicator
                  // which is almost impossible, but rather safe than sorry
                  minHeight: max(
                    0,
                    widgetMinHeight,
                  ),
                ),
                // The intrinsic height function applies the min
                // height imposed by the constrained box
                child: IntrinsicHeight(
                  child: index == 0
                      ? const ServerInputScreen()
                      : const TokenInputScreen(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
