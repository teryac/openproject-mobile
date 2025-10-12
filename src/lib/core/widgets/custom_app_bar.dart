import '../constants/app_assets.dart';
import '../styles/colors.dart';
import '../styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final bool showBackButton;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final void Function()? leadingIconAction;
  final void Function()? trailingIconAction;
  const CustomAppBar({
    required this.text,
    this.leadingIcon,
    this.leadingIconAction,
    this.trailingIcon,
    this.trailingIconAction,
    this.showBackButton = true,
    super.key,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: AppBar(
        title: Text(
          text,
          style: AppTextStyles.large.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        actions: [
          if (trailingIcon != null)
            InkWell(
              borderRadius: BorderRadius.circular(360),
              onTap: trailingIconAction,
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                child: trailingIcon,
              ),
            ),
        ],
        leading: showBackButton
            ? InkWell(
                borderRadius: BorderRadius.circular(360),
                onTap: leadingIconAction ?? () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppIcons.arrowLeft,
                    width: 24,
                    height: 24,
                    theme: const SvgTheme(
                      currentColor: AppColors.iconPrimary,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
