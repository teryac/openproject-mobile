import 'dart:math';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/auth/screens/server_input_screen.dart';
import 'package:open_project/auth/screens/token_input_screen.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/sliver_util.dart';
import 'package:sliver_fill_remaining_box_adapter/sliver_fill_remaining_box_adapter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _pageViewController = PageController();
  int _currentPage = 0;

  void _changePage(int index) {
    setState(() {
      _currentPage = index;
    });

    _pageViewController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (_currentPage == 1)
                      GestureDetector(
                        onTap: () => _changePage(0),
                        child: Align(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              AppIcons.arrowLeft,
                              width: 24,
                              height: 24,
                              // ignore: deprecated_member_use
                              color: AppColors.iconPrimary,
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    SmoothPageIndicator(
                      controller: _pageViewController,
                      count: 2,
                      effect: const SlideEffect(
                        dotWidth: 96,
                        dotHeight: 8,
                        spacing: 8,
                        dotColor: AppColors.lowContrastCursor,
                        activeDotColor: AppColors.highContrastCursor,
                      ),
                    ),
                    const Spacer(),
                    if (_currentPage == 1)
                      GestureDetector(
                        onTap: () => context.goNamed(AppRoutes.home.name),
                        // Added padding to make click space larger
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Skip',
                            style: AppTextStyles.small.copyWith(
                              color: AppColors.descriptiveText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Builder(
                builder: (context) {
                  return ExpandablePageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageViewController,
                    children: List.generate(
                      2,
                      (index) {
                        final widgetMinHeight =
                            MediaQuery.sizeOf(context).height -
                                MediaQuery.paddingOf(context).top -
                                MediaQuery.paddingOf(context).bottom -
                                100;

                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            // For the previewed widget, set a minimum height of
                            // the screen size without the safe area padding, and
                            // without an approximate height of the pageview
                            // indicator widget at the top, and some extra space
                            // because `ServerInputScreen` and `TokenInputScreen`
                            // both contain a spacer widget, and a spacer widget
                            // needs a finite height, therefore some extra space
                            // is needed to see its effect in app.

                            // The max function is for safety, just in case
                            // `widgetMinHeight` goes below zero, which means the
                            // screen size is less than the pageview indicator
                            // which is almost impossible, but rather safe than sorry
                            minHeight: max(
                              0,
                              widgetMinHeight,
                            ),
                          ),
                          // The intrinsic height function applies the min
                          // height imposed by the constrained box
                          child: IntrinsicHeight(
                            child: index == 0
                                ? ServerInputScreen(
                                    navigateToNextPageHandler: () =>
                                        _changePage(1),
                                  )
                                : const TokenInputScreen(),
                          ),
                        );
                      },
                    ),
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
