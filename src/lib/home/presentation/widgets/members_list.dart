import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class MembersList extends StatelessWidget {
  final List<({String fullName, Color color})> members;
  const MembersList({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: Row(
        spacing: 0,
        children: [
          // Iterate throught list with a max of 3
          for (int i = 0; i < min(members.length, 3); i++)
            Transform.translate(
              offset: Offset(
                  i * (-12) * MediaQuery.textScalerOf(context).scale(1), 0),
              child: MemberAvatarWidget(
                fullName: members[i].fullName,
                color: members[i].color,
                extraMembersOverlayCount:
                    (members.length > 3 && i == 2) ? members.length - 3 : null,
              ),
            )
        ],
      ),
    );
  }
}

class MemberAvatarWidget extends StatelessWidget {
  final String fullName;
  final Color color;
  final double radius;
  final bool _border;
  // When not null, the profile image is blurred, and a '+x' is added
  // on top to indicate that there are more members available -when used
  // as a members list-, and 'x' value is `extraMembersOverlayCount` value
  final int? extraMembersOverlayCount;

  const MemberAvatarWidget({
    super.key,
    required this.fullName,
    required this.color,
    this.radius = 22.5,
    this.extraMembersOverlayCount,
  }) : _border = true;

  const MemberAvatarWidget.noBorder({
    super.key,
    required this.fullName,
    required this.color,
    this.radius = 22.5,
    this.extraMembersOverlayCount,
  }) : _border = false;

  @override
  Widget build(BuildContext context) {
    final nameWords = fullName.split(' ');
    final containerDiameter =
        radius * 2 * MediaQuery.textScalerOf(context).scale(1);
    // This modifies the text size based on the diameter of the container
    const textToDiameterModifier = 0.35;

    String getFirstCharacter(String? word) {
      return word?.split('').firstOrNull ?? '?';
    }

    return Stack(
      children: [
        Container(
          width: containerDiameter,
          height: containerDiameter,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: _border
                ? Border.all(color: AppColors.projectBackground, width: 2)
                : null,
          ),
          child: Text(
            getFirstCharacter(nameWords[0]) +
                getFirstCharacter(nameWords.length > 1 ? nameWords.last : null),
            style: AppTextStyles.medium.copyWith(
              color: AppColors.background,
              fontSize: containerDiameter * textToDiameterModifier,
            ),
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
