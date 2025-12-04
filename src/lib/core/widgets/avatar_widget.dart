import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/api_constants.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_image.dart';

class AvatarWidget extends StatelessWidget {
  /// When user data is null, a blue background with a profile icon is shown
  final ({int id, String fullName})? userData;
  final double radius;
  final bool _border;
  final String? svgAssetFallback;
  final double fallbackIconSize;

  /// When not null, the profile image is blurred, and a '+x' is added
  /// on top to indicate that there are more members available -when used
  /// as a members list-, and 'x' value is `extraMembersOverlayCount` value
  final int? extraMembersOverlayCount;

  const AvatarWidget({
    super.key,
    required this.userData,
    this.radius = 22.5,
    this.extraMembersOverlayCount,
    this.svgAssetFallback,
    this.fallbackIconSize = 24,
  }) : _border = true;

  const AvatarWidget.noBorder({
    super.key,
    required this.userData,
    this.radius = 22.5,
    this.extraMembersOverlayCount,
    this.svgAssetFallback,
    this.fallbackIconSize = 24,
  }) : _border = false;

  @override
  Widget build(BuildContext context) {
    final containerDiameter =
        radius * 2 * MediaQuery.textScalerOf(context).scale(1);
    // This modifies the text size based on the diameter of the container
    const textToDiameterModifier = 0.35;

    final invalidAvatar = userData == null
        ? true
        : (context.read<CacheCubit>().state[
                AppConstants.memberAvatarDoesntExistCacheKey(userData!.id)] !=
            null);

    final color = userData != null
        ? _getColorForString('${userData!.id}${userData!.fullName}')
        : AppColors.blue100;

    final Widget fallbackAvatar = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: userData == null
          ? SvgPicture.asset(
              svgAssetFallback ?? AppIcons.profileFilled,
              width: fallbackIconSize,
              height: fallbackIconSize,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            )
          : Text(
              _getInitials(userData!.fullName),
              style: AppTextStyles.medium.copyWith(
                color: AppColors.background,
                fontSize: containerDiameter * textToDiameterModifier,
              ),
            ),
    );
    return Stack(
      children: [
        Container(
          width: containerDiameter,
          height: containerDiameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: _border
                ? Border.all(color: AppColors.projectBackground, width: 2)
                : null,
          ),
          child: (userData?.id == null || invalidAvatar)
              ? fallbackAvatar
              : Builder(
                  builder: (context) {
                    final serverUrl = context
                        .read<CacheCubit>()
                        .state[AppConstants.serverUrlCacheKey];
                    final avatarEndpoint =
                        ApiConstants.userAvatar(userData!.id.toString());

                    return AppNetworkImage(
                      imageUrl: '$serverUrl$avatarEndpoint',
                      borderRadius: BorderRadius.circular(360),
                      cacheDuration: const Duration(minutes: 5),
                      errorBuilder: (_) {
                        if (userData == null) return fallbackAvatar;

                        final cacheCubit = context.read<CacheCubit>();
                        cacheCubit.addCacheValue(
                          AppConstants.memberAvatarDoesntExistCacheKey(
                              userData!.id),
                          'true',
                        );

                        return fallbackAvatar;
                      },
                    );
                  },
                ),
        ),
        if (extraMembersOverlayCount != null)
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(360),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              child: Container(
                width: containerDiameter,
                height: containerDiameter,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x80505358),
                  border: _border
                      ? Border.all(color: AppColors.projectBackground, width: 2)
                      : null,
                ),
                child: Text(
                  '+$extraMembersOverlayCount',
                  style: AppTextStyles.medium.copyWith(
                    color: AppColors.background,
                    fontSize: containerDiameter * textToDiameterModifier,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Generates the initials from a full name.
///
/// This logic matches the OpenProject `getInitials` function.
String _getInitials(String name) {
  String safeName = name.trim();
  if (safeName.isEmpty) return '?'; // Fallback for empty names

  final first = safeName[0].toUpperCase();
  final lastSpace = safeName.lastIndexOf(' ');

  // If no space, or if the name ends with a space, just return the first initial
  if (lastSpace == -1 || lastSpace + 1 == safeName.length) {
    return first;
  }

  // Get the character after the last space
  final last = safeName[lastSpace + 1].toUpperCase();
  return '$first$last';
}

/// Generates a deterministic HSL color for a given string.
///
/// This logic matches the OpenProject `valueHash` and `toHsl` functions.
Color _getColorForString(String input) {
  int hash = 0;

  // This is a Dart port of the `djb2` hash function:
  // hash = value.charCodeAt(i) + ((hash << 5) - hash);
  for (int i = 0; i < input.length; i++) {
    hash = input.codeUnitAt(i) + ((hash << 5) - hash);

    // This is the critical part:
    // We must force the hash to be a 32-bit signed integer
    // to match the behavior of JavaScript's bitwise operators.
    hash = hash.toSigned(32);
  }

  // Get a positive hue value between 0 and 359
  final int hue = hash.remainder(360);
  final double hueDouble = ((hue < 0) ? hue + 360 : hue).toDouble();

  // This matches the HSL(hue, 50%, 30%) from the JS code
  final hslColor = HSLColor.fromAHSL(
    1.0, // Alpha (1.0 = opaque)
    hueDouble, // Hue (0-360)
    0.6, // Saturation (0.0 - 1.0, so 50%)
    0.5, // Lightness (0.0 - 1.0, so 30%)
  );

  return hslColor.toColor();
}
