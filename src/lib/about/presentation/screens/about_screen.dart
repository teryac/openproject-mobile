import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:open_project/about/application/about_controller.dart';
import 'package:open_project/about/presentation/widgets/app_identification_card.dart';
import 'package:open_project/about/presentation/widgets/version_tile.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/custom_app_bar.dart';
import 'package:open_project/core/widgets/sliver_util.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AboutController>();

    return Scaffold(
      appBar: CustomAppBar(text: 'About'),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    SliverList.list(
                      children: [
                        _InfoTile(
                          title: 'Copy rights',
                          description: controller.getCopyRights(),
                        ),
                        _InfoTile(
                          title: 'Data safety',
                          description: controller.getDataSafety(),
                        ),
                        _InfoTile(
                          title: 'Report an issue',
                          description: controller.getFeedback(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Change log',
                          style: AppTextStyles.medium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    SliverList.separated(
                      itemCount: controller.getVersions().length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return VersionTile(
                          version:
                              controller.getVersions().reversed.toList()[index],
                        );
                      },
                    ),
                    SliverIndent(height: 200),
                  ],
                ),
              ),
            ],
          ),
          AppIdentificationCard(
            version: controller.getVersions().last.name,
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String description;
  const _InfoTile({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.medium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          MarkdownBody(
            data: description,
            onTapLink: (_, href, __) async {
              if (href != null) {
                final url = Uri.parse(href);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              }
            },
            styleSheet: MarkdownStyleSheet(
              p: AppTextStyles.small.copyWith(
                color: AppColors.descriptiveText,
              ),
              strong: AppTextStyles.small.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.descriptiveText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
