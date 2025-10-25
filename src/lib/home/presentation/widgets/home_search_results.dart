import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/async_retry.dart';
import 'package:open_project/home/application/home_controller.dart';
import 'package:open_project/home/models/paginated_projects.dart';
import 'package:open_project/home/presentation/cubits/projects_data_cubit.dart';

class HomeSearchResults extends StatelessWidget {
  final void Function(bool) toggleMenu;
  const HomeSearchResults({super.key, required this.toggleMenu});

  @override
  Widget build(BuildContext context) {
    const menuBackgroundColor = AppColors.background;
    const menuBorderRadius = 16.0;

    return BlocBuilder<SearchDialogProjectsCubit,
        PaginatedAsyncValue<PaginatedProjects, NetworkFailure>>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: menuBackgroundColor,
            border: Border.all(color: AppColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(menuBorderRadius),
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
                  final searchQuery =
                      context.read<HomeController>().searchTextController.text;
                  if (searchQuery.isEmpty) return;

                  context.read<SearchDialogProjectsCubit>().getProjects(
                        projectsFilters: ProjectsFilters(
                          name: searchQuery,
                        ),
                      );
                },
              );
            },
            data: (context, data) {
              if (data.projects.isEmpty) {
                return const _NoResultsFoundWidget();
              }

              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.separated(
                  itemCount: data.projects.length,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: AppColors.border,
                        thickness: 1,
                        height: 0,
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                    final project = data.projects[index];
                    // TODO: Change status color
                    const statusColorHex = '#2392D4';

                    BorderRadius getBorderRadius() {
                      if (data.projects.length == 1) {
                        // If there is one item, make all corners rounded
                        return BorderRadius.circular(menuBorderRadius);
                      } else if (index == 0) {
                        // First item is rounded from top
                        return const BorderRadius.only(
                          topLeft: Radius.circular(menuBorderRadius),
                          topRight: Radius.circular(menuBorderRadius),
                        );
                      } else if (index == data.projects.length - 1) {
                        // Last item is rounded from bottom
                        return const BorderRadius.only(
                          bottomLeft: Radius.circular(menuBorderRadius),
                          bottomRight: Radius.circular(menuBorderRadius),
                        );
                      } else {
                        return BorderRadius.zero;
                      }
                    }

                    return Material(
                      color: menuBackgroundColor,
                      borderRadius: getBorderRadius(),
                      child: InkWell(
                        onTap: () {
                          toggleMenu(false);
                          context.pushNamed(
                            AppRoutes.workPackages.name,
                            pathParameters: {
                              'project_id': project.id.toString(),
                            },
                          );
                        },
                        borderRadius: getBorderRadius(),
                        splashColor: AppColors.primaryText.withAlpha(38),
                        highlightColor:
                            Colors.transparent, // Removes gray overlay
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: _highlightOccurrences(
                                          project.name,
                                          data.projectsFilters.name,
                                          AppTextStyles.medium.copyWith(
                                            color: AppColors.primaryText,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          AppTextStyles.medium.copyWith(
                                            color: AppColors.primaryText,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      project.public
                                          ? 'Public project'
                                          : 'Private project',
                                      style: AppTextStyles.small.copyWith(
                                        color: AppColors.descriptiveText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: project.status == null
                                    ? const SizedBox.shrink()
                                    : Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: HexColor(statusColorHex)
                                                .withAlpha(15),
                                            borderRadius:
                                                BorderRadius.circular(360),
                                          ),
                                          child: Text(
                                            // Widget won't be shown if `status` is null
                                            project.status!,
                                            style: AppTextStyles.extraSmall
                                                .copyWith(
                                              color: HexColor(statusColorHex),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
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

/// This function is used to highlight part of the project name
/// that matches the search query
List<TextSpan> _highlightOccurrences(
  String source,
  String? query,
  TextStyle normalStyle,
  TextStyle highlightStyle,
) {
  if (query == null || query.isEmpty) {
    return [
      TextSpan(text: source, style: normalStyle),
    ];
  }

  final matches = <TextSpan>[];
  final lowerSource = source.toLowerCase();
  final lowerQuery = query.toLowerCase();

  int start = 0;
  while (true) {
    final index = lowerSource.indexOf(lowerQuery, start);
    if (index < 0) {
      // no more matches
      matches.add(TextSpan(text: source.substring(start), style: normalStyle));
      break;
    }

    if (index > start) {
      matches.add(
        TextSpan(
          text: source.substring(start, index),
          style: normalStyle,
        ),
      );
    }

    matches.add(
      TextSpan(
        text: source.substring(index, index + query.length),
        style: highlightStyle,
      ),
    );

    start = index + query.length;
  }

  return matches;
}
