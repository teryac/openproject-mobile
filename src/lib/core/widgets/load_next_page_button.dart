import 'package:flutter/material.dart';
import 'package:open_project/core/widgets/app_button.dart';

class LoadNextPageButton extends StatelessWidget {
  final void Function() onTap;
  const LoadNextPageButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      text: 'Load more',
      onPressed: onTap,
    );
  }
}
