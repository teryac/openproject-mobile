import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/home/widgets/home_header.dart';
import 'package:open_project/home/widgets/project_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //List<Project> data = [Project(description: "No description", name: "Secrum", id: 1),Project(description: "No description", name: "Demo", id: 2),Project(description: "No description", name: "Secrum", id: 1),];
    return Scaffold(
      body: SafeArea(
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
                    // ignore: deprecated_member_use
                    color: AppColors.iconSecondary,
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
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: 1,
                  itemBuilder: (BuildContext ctx, int index) {
                    /*name = data[index].name;
                      description = data[index].description;
                      id = data[index].id;*/
                    return const ProjectTile();
                  },
                ),
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
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: 1,
                  itemBuilder: (BuildContext ctx, int index) {
                    /*name = data[index].name;
                      description = data[index].description;
                      id = data[index].id;*/
                    return const ProjectTile();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
