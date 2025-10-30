import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/async_retry.dart';
import 'package:open_project/core/widgets/search_result_occurrence_highlighter.dart';
import 'package:open_project/work_packages/application/work_packages_controller.dart';
import 'package:open_project/work_packages/models/paginated_work_packages.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';

class WorkPackagesSearchResults extends StatelessWidget {
  final void Function(bool) toggleMenu;
  const WorkPackagesSearchResults({super.key, required this.toggleMenu});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchDialogWorkPackagesCubit,
        PaginatedAsyncValue<PaginatedWorkPackages, NetworkFailure>>(
      builder: (context, state) {
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
          child: AsyncValueBuilder(
            value: state,
            initial: (context) {
              return const _NoResultsFoundWidget();
            },
            loading: (context) {
              return const Align(
                heightFactor: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(),
                ),
              );
            },
            error: (context, error) {
              return AsyncRetryWidget(
                message: error.errorMessage,
                onPressed: () {
                  final searchQuery = context
                      .read<WorkPackagesController>()
                      .searchTextController
                      .text;
                  if (searchQuery.isEmpty) return;

                  final projectId = int.parse(
                    GoRouterState.of(context).pathParameters['project_id']!,
                  );

                  context.read<SearchDialogWorkPackagesCubit>().getWorkPackages(
                        projectId: projectId,
                        workPackagesFilters: WorkPackagesFilters(
                          name: searchQuery,
                        ),
                      );
                },
              );
            },
            data: (context, data) {
              final workPackages = data.workPackages;

              if (workPackages.isEmpty) {
                return const _NoResultsFoundWidget();
              }

              return ConstrainedBox(
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
                        onTap: () {
                          toggleMenu(false);
                          context.pushNamed(AppRoutes.viewWorkPackage.name);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            spacing: 12,
                            children: [
                              Expanded(
                                flex: 7,
                                child: SearchResultOccurrenceHighlighter(
                                  source: workPackages[index].subject,
                                  query: data.workPackagesFilters.name,
                                  normalStyle: AppTextStyles.medium.copyWith(
                                    color: AppColors.primaryText,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  highlightStyle: AppTextStyles.medium.copyWith(
                                    color: AppColors.primaryText,
                                    fontWeight: FontWeight.w600,
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
                                      color: HexColor(
                                        workPackages[index].status.colorHex,
                                      ).withAlpha(38),
                                      borderRadius: BorderRadius.circular(360),
                                    ),
                                    child: Text(
                                      workPackages[index].status.name,
                                      style: AppTextStyles.extraSmall.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: HexColor(
                                          workPackages[index].status.colorHex,
                                        ),
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
              );
            },
          ),
        );
      },
    );
  }
}

class _NoResultsFoundWidget extends StatelessWidget {
  const _NoResultsFoundWidget();

  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No results found',
          style: AppTextStyles.small.copyWith(
            color: AppColors.descriptiveText,
          ),
        ),
      ),
    );
  }
}
