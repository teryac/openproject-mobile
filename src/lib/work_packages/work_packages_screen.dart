import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/app_chip.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/core/widgets/custom_app_bar.dart';
import 'package:open_project/work_packages/models/work_package_model.dart';
// import 'package:open_project/work_packages/widgets/search_results_dialog.dart';
import 'package:open_project/work_packages/widgets/work_package_tile.dart';

class WorkPackagesScreen extends StatelessWidget {
  const WorkPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return const Scaffold(
    //   backgroundColor: Colors.amber,
    //   body: Center(
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 20),
    //       child: SearchResultsDialog(
    //         workPackages: [
    //           (
    //             name: 'Set date and location of project',
    //             type: 'Task',
    //             typeColor: '#2392D4',
    //           ),
    //           (
    //             name: 'Send invitation to Shaaban',
    //             type: 'Milestone',
    //             typeColor: '#2EAC5D',
    //           ),
    //           (
    //             name: 'Password not protected',
    //             type: 'Bug',
    //             typeColor: '#F84616',
    //           ),
    //           (
    //             name: 'Release v1.1',
    //             type: 'Milestone',
    //             typeColor: '#2EAC5D',
    //           ),
    //           (
    //             name: 'Release v1.0',
    //             type: 'Milestone',
    //             typeColor: '#2EAC5D',
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    const workPackages = [
      WorkPackageModel(
        title: 'Organize open source',
        assignee: 'Shaaban Shahin',
        status: 'in progress',
        statusColor: '#2EAC5D',
      ),
      WorkPackageModel(
        title: 'Organize open source',
        assignee: 'Shaaban Shahin',
        status: 'in progress',
        statusColor: '#2EAC5D',
      ),
      WorkPackageModel(
        title: 'Organize open source',
        assignee: 'Shaaban Shahin',
        status: 'in progress',
        statusColor: '#2EAC5D',
      ),
    ];

    return Portal(
      child: Scaffold(
        appBar: const CustomAppBar(text: 'Scrum Project'),
        floatingActionButton: AppButton(
          text: 'Add Work Package',
          prefixIcon: SvgPicture.asset(
            AppIcons.task,
            width: 20,
            height: 20,
            // ignore: deprecated_member_use
            color: Colors.white,
          ),
          wrapContent: true,
          onPressed: () {
            context.pushNamed(AppRoutes.addWorkPackage.name);
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTextFormField.filled(
                  hint: 'Search for tasks in this project..',
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
              ),
              const SizedBox(height: 12),
              AppChipList(
                chips: [
                  AppChip(
                    text: 'In progress',
                    isSelected: true,
                    onPressed: () {},
                  ),
                  ...List.filled(
                    7,
                    AppChip(
                      text: 'New',
                      isSelected: false,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListView.separated(
                itemCount: workPackages.length,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return WorkPackageTile(
                    title: workPackages[index].title,
                    assignee: workPackages[index].assignee,
                    status: workPackages[index].status,
                    statusColor: workPackages[index].statusColor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
