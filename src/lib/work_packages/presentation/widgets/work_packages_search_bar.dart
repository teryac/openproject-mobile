import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';
import 'package:open_project/work_packages/application/work_packages_controller.dart';
import 'package:open_project/work_packages/models/work_package_filters.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';
import 'package:open_project/work_packages/presentation/widgets/work_packages_search_results.dart';

class WorkPackagesSearchBar extends StatelessWidget {
  const WorkPackagesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPopupMenu(
      toggleOnChildTap: false,
      dropdownAlignment: true,
      menu: (toggleMenu) {
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width -
                MediaQuery.paddingOf(context)
                    .horizontal - // Horizontal safe area
                40 // Screen Horizontal Padding
            ,
            child: WorkPackagesSearchResults(toggleMenu: toggleMenu),
          ),
        );
      },
      child: (toggleMenu) {
        return AppTextFormField.filled(
          controller:
              context.read<WorkPackagesController>().searchTextController,
          hint: 'Search for tasks in this project..',
          unFocusOnTapOutside: true,
          onTap: () => toggleMenu(true),
          onFieldSubmitted: (query) {
            final searchDialogWorkPackagessCubit =
                context.read<SearchDialogWorkPackagesCubit>();

            if (query.isEmpty) {
              toggleMenu(false);
              searchDialogWorkPackagessCubit.reset();

              return;
            }

            final projectId = int.parse(
              GoRouterState.of(context).pathParameters['project_id']!,
            );

            searchDialogWorkPackagessCubit.getWorkPackages(
              context: context,
              projectId: projectId,
              workPackagesFilters: WorkPackagesFilters(name: query),
              resetPages: true,
            );
            toggleMenu(true);
          },
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
        );
      },
    );
  }
}
