import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/home/models/project_model.dart';
import 'package:open_project/home/widgets/home_header.dart';
import 'package:open_project/home/widgets/project_tile.dart';
// import 'package:open_project/home/widgets/search_results.dart';
// import 'package:open_project/home/widgets/servers_dialog.dart';
// import 'package:open_project/ready_widgets_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<ProjectModel> projects = [
    ProjectModel(
        projectName: "Scrum project",
        status: "On track",
        statusColor: "#2EAC5D"),
    ProjectModel(
        projectName: "Demo project",
        status: "Off track",
        statusColor: "#F84616")
  ];
  @override
  Widget build(BuildContext context) {
    // return SearchResults();
    // return ServersDialog();
    // return const ReadyWidgetsSheet();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const HomeHeader(),
                const SizedBox(height: 24),
                AppTextFormField.filled(
                  hint: 'Search for Projects..',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: SvgPicture.asset(
                      AppIcons.search,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.iconSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Public projects",
                      style: AppTextStyles.large
                          .copyWith(color: AppColors.primaryText),
                    ),
                    SvgPicture.asset(
                      AppIcons.arrowUp,
                      width: 24.0,
                      height: 24.0,
                      colorFilter: const ColorFilter.mode(
                        AppColors.iconPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: projects.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return ProjectTile(
                      projectName: projects[index].projectName,
                      status: projects[index].status,
                      statusColor: projects[index].statusColor,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 16.0),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Private projects",
                      style: AppTextStyles.large
                          .copyWith(color: AppColors.primaryText),
                    ),
                    /*SvgPicture.asset(
                      AppIcons.arrowUp,
                      width: 24.0,
                      height: 24,
                      color: AppColors.iconPrimary,
                    ),*/
                  ],
                ),
                const SizedBox(height: 20.0),
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  itemCount: projects.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return ProjectTile(
                      projectName: projects[index].projectName,
                      status: projects[index].status,
                      statusColor: projects[index].statusColor,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
