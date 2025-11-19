import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/util/app_snackbar.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/custom_app_bar.dart';
import 'package:open_project/work_packages/models/paginated_work_packages.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_filters_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';
import 'package:open_project/work_packages/presentation/widgets/work_packages_filters_widget.dart';
import 'package:open_project/work_packages/presentation/widgets/work_packages_list.dart';
import 'package:open_project/work_packages/presentation/widgets/work_packages_search_bar.dart';

class WorkPackagesScreen extends StatelessWidget {
  final int projectId;
  final String projectName;
  const WorkPackagesScreen({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkPackagesListCubit,
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
      child: Portal(
        child: Scaffold(
          appBar: CustomAppBar(text: projectName),
          floatingActionButton: Builder(
            builder: (context) {
              final apiToken = context
                  .read<CacheCubit>()
                  .state[AppConstants.apiTokenCacheKey];

              // Unauthenticated users can't add work packages
              if (apiToken == null) {
                return SizedBox.shrink();
              }

              return AppButton(
                text: 'Add Work Package',
                prefixIcon: SvgPicture.asset(
                  AppIcons.task,
                  width: 20,
                  height: 20,
                  // ignore: deprecated_member_use
                  color: Colors.white,
                ),
                wrapContent: true,
                onPressed: () async {
                  final result = await context.pushNamed<bool>(
                    AppRoutes.addWorkPackage.name,
                    pathParameters: {
                      'work_package_id': 'null',
                    },
                    queryParameters: {
                      'edit_mode': 'false',
                      'project_id': projectId.toString(),
                    },
                  );

                  if (result != null && result && context.mounted) {
                    context.read<WorkPackagesListCubit>().getWorkPackages(
                          context: context,
                          projectId: projectId,
                          workPackagesFilters:
                              // This avoids changing the filters
                              context.read<WorkPackagesFiltersCubit>().state,
                          // Reset to avoid requesting next page instead of first page
                          resetPages: true,
                        );
                  }
                },
              );
            },
          ),
          body: const SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: WorkPackagesSearchBar(),
                ),
                SizedBox(height: 12),
                WorkPackagesFiltersWidget(),
                SizedBox(height: 24),
                WorkPackagesList(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
