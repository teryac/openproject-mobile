import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';
import 'package:open_project/home/application/home_controller.dart';
import 'package:open_project/home/models/paginated_projects.dart';
import 'package:open_project/home/presentation/cubits/projects_data_cubit.dart';
import 'package:open_project/home/presentation/widgets/home_search_results.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPopupMenu(
      dropdownAlignment: true,
      disableChildOverylay: true,
      menu: (toggleMenu) {
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width -
                MediaQuery.paddingOf(context)
                    .horizontal - // Horizontal safe area
                40 // Screen Horizontal Padding
            ,
            child: HomeSearchResults(toggleMenu: toggleMenu),
          ),
        );
      },
      child: (toggleMenu) {
        return AppTextFormField.filled(
          controller: context.read<HomeController>().searchTextController,
          hint: 'Search for Projects..',
          onTap: () => toggleMenu(true),
          onFieldSubmitted: (query) {
            final searchDialogProjectsCubit =
                context.read<SearchDialogProjectsCubit>();

            if (query.isEmpty) {
              toggleMenu(false);
              searchDialogProjectsCubit.reset();

              return;
            }

            // Reset pagination status to get new products instead of
            // a new page
            searchDialogProjectsCubit.reset();
            searchDialogProjectsCubit.getProjects(
              projectsFilters: ProjectsFilters(name: query),
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
