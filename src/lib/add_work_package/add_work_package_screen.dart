import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:open_project/add_work_package/widgets/work_package_description/work_package_description.dart';
import 'package:open_project/add_work_package/widgets/work_package_overview/work_package_overview.dart';
import 'package:open_project/add_work_package/widgets/work_package_people/work_package_people.dart';
import 'package:open_project/add_work_package/widgets/work_package_priority/work_package_priority.dart';
import 'package:open_project/add_work_package/widgets/work_package_progress/work_package_progress.dart';
import 'package:open_project/add_work_package/widgets/work_package_properties/work_package_properties.dart';
import 'package:open_project/add_work_package/widgets/work_package_schedule/work_package_schedule.dart';
import 'package:open_project/add_work_package/widgets/work_package_status/work_package_status.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/custom_app_bar.dart';

class AddWorkPackageScreen extends StatelessWidget {
  const AddWorkPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const screenPadding = EdgeInsets.symmetric(horizontal: 20);

    return const Portal(
      child: Scaffold(
        // TODO: Change to 'Edit task' in edit mode
        appBar: CustomAppBar(text: 'Create a task'),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                // Overview
                Padding(
                  padding: screenPadding,
                  child: WorkPackageOverview(),
                ),
                SizedBox(height: 20),
                // Status
                WorkPackageStatus(screenPadding: screenPadding),
                SizedBox(height: 20),
                Padding(
                  padding: screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      WorkPackageDescription(),
                      SizedBox(height: 48),
                      // People
                      WorkPackagePeople(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                // Priority
                WorkPackagePriority(
                  screenPadding: screenPadding,
                ),
                SizedBox(height: 48),
                Padding(
                  padding: screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Schedule and Estimates
                      WorkPackageSchedule(),
                      SizedBox(height: 48),
                      // Properties
                      WorkPackageProperties(),
                      SizedBox(height: 20),
                      // Progress
                      WorkPackageProgress(),
                      SizedBox(height: 32),
                      AppButton(
                        text: 'Create task',
                        onPressed: null,
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
