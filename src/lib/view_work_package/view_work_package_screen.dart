import 'package:flutter/material.dart';
import 'package:open_project/core/widgets/custom_app_bar.dart';

class ViewWorkPackageScreen extends StatelessWidget {
  const ViewWorkPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(text: 'Organize open source'),
      body: Placeholder(),
    );
  }
}