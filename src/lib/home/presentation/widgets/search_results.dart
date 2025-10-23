import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/home/models/search_model.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  static List<SearchModel> projects = [
    SearchModel(
        projectName: "OpenProject-mobile",
        status: "Finished",
        statusColor: "#743CAC",
        typeProject: "Private project"),
    SearchModel(
        projectName: "Secrum project",
        status: "On track",
        statusColor: "#2EAC5D",
        typeProject: "Private project"),
    SearchModel(
        projectName: "Demo project",
        status: "Off track",
        statusColor: "#F84616",
        typeProject: "Public project")
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.projectBackground,
        border: Border.all(color: AppColors.border, width: 1.5),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              projects[index].projectName,
              style:
                  AppTextStyles.medium.copyWith(color: AppColors.primaryText),
            ),
            subtitle: Text(
              projects[index].typeProject,
              style: AppTextStyles.small
                  .copyWith(color: AppColors.descriptiveText),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: HexColor(projects[index].statusColor).withAlpha(15),
                  borderRadius: BorderRadius.circular(360)),
              child: Text(
                projects[index].status,
                // I Want a style text is Small.
                style: AppTextStyles.extraSmall.copyWith(
                  color: HexColor(projects[index].statusColor),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
