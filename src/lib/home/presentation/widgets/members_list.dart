import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_project/core/widgets/avatar_widget.dart';

class MembersList extends StatelessWidget {
  final List<({int id, String fullName})> members;
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
              child: AvatarWidget(
                userData: members[i],
                extraMembersOverlayCount:
                    (members.length > 3 && i == 2) ? members.length - 3 : null,
              ),
            )
        ],
      ),
    );
  }
}
