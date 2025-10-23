import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/widgets/shimmer.dart';

class ProjectTileLoadingView extends StatelessWidget {
  const ProjectTileLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.projectBackground,
        border: Border.all(color: AppColors.border, width: 1.0),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: 250,
            height: 50,
          ),
          SizedBox(height: 16),
          ShimmerBox(
            width: 140,
            height: 50,
          ),
        ],
      ),
    );
  }
}
