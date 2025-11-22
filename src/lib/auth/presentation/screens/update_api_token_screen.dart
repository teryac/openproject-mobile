import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open_project/auth/presentation/screens/token_input_screen.dart';
import 'package:open_project/core/widgets/custom_app_bar.dart';

/// This screen is used to authenticated a user that is already
/// connected to a server
class UpdateApiTokenScreen extends StatelessWidget {
  const UpdateApiTokenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetMinHeight = MediaQuery.sizeOf(context).height -
            MediaQuery.paddingOf(context).top -
            MediaQuery.paddingOf(context).bottom -
            56 // This is the default height of the app bar
        ;

    return Scaffold(
      appBar: CustomAppBar(text: 'Enter API token'),
      body: SingleChildScrollView(
        child: ConstrainedBox(
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
            child: TokenInputScreen(),
          ),
        ),
      ),
    );
  }
}
