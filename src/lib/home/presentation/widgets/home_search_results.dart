import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/async_retry.dart';
import 'package:open_project/home/application/home_controller.dart';
import 'package:open_project/home/models/paginated_projects.dart';
import 'package:open_project/home/presentation/cubits/projects_data_cubit.dart';

class HomeSearchResults extends StatelessWidget {
  const HomeSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchDialogProjectsCubit,
        PaginatedAsyncValue<PaginatedProjects, NetworkFailure>>(
      builder: (context, state) {
        return AsyncValueBuilder(
          value: state,
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
          loading: (context) {
            return const CircularProgressIndicator();
          },
          data: (context, data) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.projectBackground,
                border: Border.all(color: AppColors.border, width: 1.5),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  itemCount: data.projects.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final project = data.projects[index];
                    // TODO: Change status color
                    const statusColorHex = '#2392D4';

                    return ListTile(
                      title: Text(
                        project.name,
                        style: AppTextStyles.medium
                            .copyWith(color: AppColors.primaryText),
                      ),
                      subtitle: Text(
                        project.public ? 'Public project' : 'Private project',
                        style: AppTextStyles.small
                            .copyWith(color: AppColors.descriptiveText),
                      ),
                      trailing: project.status == null
                          ? const SizedBox.shrink()
                          : Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: HexColor(statusColorHex).withAlpha(15),
                                  borderRadius: BorderRadius.circular(360)),
                              child: Text(
                                // Widget won't be shown if `status` is null
                                project.status!,
                                // I Want a style text is Small.
                                style: AppTextStyles.extraSmall.copyWith(
                                  color: HexColor(statusColorHex),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
