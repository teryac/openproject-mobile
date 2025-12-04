import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';
import 'package:open_project/work_packages/application/work_packages_controller.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';
import 'package:open_project/work_packages/presentation/widgets/work_packages_search_results.dart';

class WorkPackagesSearchBar extends StatelessWidget {
  const WorkPackagesSearchBar({super.key});

  void searchWorkPackages({
    required BuildContext context,
    required String query,
  }) {
    if (query.isEmpty) {
      final searchCubit = context.read<SearchDialogWorkPackagesCubit>();
      searchCubit.reset();
      searchCubit.cancelRunningRequest();

      return;
    }

    context.read<WorkPackagesController>().searchWorkPackages(
          query: query,
        );
  }

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
            child: WorkPackagesSearchResults(
              toggleMenu: toggleMenu,
            ),
          ),
        );
      },
      child: (toggleMenu) {
        return AppTextFormField.filled(
          controller:
              context.read<WorkPackagesController>().searchTextController,
          hint: 'Search for tasks in this project..',
          textStyle: AppTextStyles.small.copyWith(
            color: AppColors.primaryText,
            fontSize: 15,
          ),
          onFieldSubmitted: (query) => searchWorkPackages(
            context: context,
            query: query,
          ),
          onDebounceSubmitted: (query) => searchWorkPackages(
            context: context,
            query: query,
          ),
          onTap: () => toggleMenu(true),
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
