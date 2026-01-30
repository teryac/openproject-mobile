import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/about/models/version.dart';
import 'package:open_project/about/presentation/cubits/changelog_version_expansion_cubit.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class VersionTile extends StatelessWidget {
  final Version version;
  const VersionTile({
    required this.version,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final expansionCubit = context.read<ChangelogVersionExpansionCubit>();

    return BlocBuilder<ChangelogVersionExpansionCubit, Map<String, bool>>(
      builder: (context, state) {
        final isExpanded = expansionCubit.state[version.name] ?? false;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primaryText.withAlpha(16),
          hoverColor: AppColors.primaryText.withAlpha(16),
          highlightColor: Colors.transparent, // Removes gray overlay
          onTap: () {
            expansionCubit.toggleExpansion(version.name);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.border,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      version.name,
                      style: AppTextStyles.medium.copyWith(
                        color: AppColors.primaryText,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Align(
                        child: AnimatedRotation(
                          turns: isExpanded ? -0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn,
                          child: SvgPicture.asset(
                            AppIcons.arrowDown,
                            height: 16,
                            width: 16,
                            colorFilter: ColorFilter.mode(
                              AppColors.primaryText,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  alignment: Alignment.topCenter,
                  child: isExpanded
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 16),
                            Builder(
                              builder: (_) {
                                return MarkdownBody(
                                  data: '• ${version.changeLog.join('.\n\n• ')}.',
                                  styleSheet: MarkdownStyleSheet(
                                    p: AppTextStyles.small.copyWith(
                                      color: AppColors.descriptiveText,
                                    ),
                                    strong: AppTextStyles.small.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.descriptiveText,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
