import 'package:flutter/material.dart';
import 'package:open_project/core/widgets/async_retry.dart';

class ProjectsListErrorWidget extends StatelessWidget {
  final String errorMessage;
  final void Function() retryTrigger;
  const ProjectsListErrorWidget({
    super.key,
    required this.errorMessage,
    required this.retryTrigger,
  });

  @override
  Widget build(BuildContext context) {
    return AsyncRetryWidget(
      message: errorMessage,
      onPressed: retryTrigger,
    );
  }
}
