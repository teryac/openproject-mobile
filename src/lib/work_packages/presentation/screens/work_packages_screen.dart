import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/util/app_snackbar.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/app_chip.dart';
import 'package:open_project/core/widgets/custom_app_bar.dart';
import 'package:open_project/work_packages/models/paginated_work_packages.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';
import 'package:open_project/work_packages/presentation/widgets/work_packages_list.dart';
import 'package:open_project/work_packages/presentation/widgets/work_packages_search_bar.dart';

class WorkPackagesScreen extends StatelessWidget {
  final int projectId;
  const WorkPackagesScreen({super.key, required this.projectId});

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

    return MultiBlocListener(
      listeners: [
        BlocListener<WorkPackagesListCubit,
            PaginatedAsyncValue<PaginatedWorkPackages, NetworkFailure>>(
          listener: (context, state) {
            // If requesting more items failed, show an error snackbar.
            // This isn't shown if the request failed on the first requested
            // page, because the error state is clearly visible on the UI as
            // a retry button (Check `widgets/projects_list_widget.dart`)
            if (state.hasPageError) {
              showErrorSnackBar(context, state.error!.errorMessage);
            }
          },
        ),
      ],
      child: Portal(
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: WorkPackagesSearchBar(),
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
                const WorkPackagesList(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
