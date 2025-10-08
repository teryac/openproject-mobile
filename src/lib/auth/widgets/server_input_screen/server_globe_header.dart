import 'package:flutter/material.dart';
import 'package:open_project/auth/widgets/server_input_screen/connection_state_widget.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/widgets/app_image.dart';

class ServerGlobeHeader extends StatelessWidget {
  final bool hasConnectedToServer;
  const ServerGlobeHeader({
    super.key,
    required this.hasConnectedToServer,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AppAssetImage(
          assetPath: AppImages.globe,
          height: 255,
          fit: BoxFit.fitHeight,
        ),
        Positioned(
          top: 0,
          right: 40,
          left: 40,
          bottom: 0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: ConnectionStateWidget(
              connected: hasConnectedToServer,
            ),
          ),
        ),
      ],
    );
  }
}
