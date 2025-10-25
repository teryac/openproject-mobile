import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class SearchResultsDialog extends StatelessWidget {
  final List<({String name, String type, String typeColor})> workPackages;
  const SearchResultsDialog({super.key, required this.workPackages});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 49),
            color: Color(0x00363636),
          ),
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 31),
            color: Color(0x03363636),
          ),
          BoxShadow(
            blurRadius: 11,
            offset: Offset(0, 18),
            color: Color(0x0A363636),
          ),
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 8),
            color: Color(0x12363636),
          ),
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 2),
            color: Color(0x14363636),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: ListView.separated(
          padding: const EdgeInsets.all(0),
          itemCount: workPackages.length,
          shrinkWrap: true,
          separatorBuilder: (_, __) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 0,
                color: AppColors.border,
                thickness: 1,
              ),
            );
          },
          itemBuilder: (context, index) {
            return Material(
              color: AppColors.background,
              child: InkWell(
                splashColor: AppColors.primaryText.withAlpha(38),
                highlightColor: Colors.transparent,
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          workPackages[index].name,
                          style: AppTextStyles.medium.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: HexColor(workPackages[index].typeColor)
                                  .withAlpha(38),
                              borderRadius: BorderRadius.circular(360),
                            ),
                            child: Text(
                              workPackages[index].type,
                              style: AppTextStyles.extraSmall.copyWith(
                                fontWeight: FontWeight.w500,
                                color: HexColor(workPackages[index].typeColor),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
