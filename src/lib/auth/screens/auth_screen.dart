import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/auth/widgets/get_server.dart';
import 'package:open_project/auth/widgets/get_token.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
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
              ExpandablePageView(
                controller: _pageViewController,
                children: [
                  GetServer(
                    navigateToNextPageHandler: () => _changePage(1),
                  ),
                  const GetToken(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
