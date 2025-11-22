import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/auth/application/auth_controller.dart';
import 'package:open_project/auth/presentation/cubits/auth_ping_server_cubit.dart';
import 'package:open_project/auth/presentation/widgets/server_input_screen/server_globe_header.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/app_text_field.dart';

class ServerInputScreen extends StatefulWidget {
  const ServerInputScreen({
    super.key,
  });

  @override
  State<ServerInputScreen> createState() => _ServerInputScreenState();
}

class _ServerInputScreenState extends State<ServerInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Once the server is successfully pinged, this widget
        // will start the connection success animation
        BlocBuilder<AuthPingServerCubit, AsyncValue<void, NetworkFailure>>(
          builder: (context, state) {
            return ServerGlobeHeader(
              hasConnectedToServer: state.isData,
            );
          },
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                'Your projects, One link away',
                textAlign: TextAlign.center,
                style: AppTextStyles.extraLarge.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the server URL to connect with your team’s workspace and access your ongoing projects.',
                textAlign: TextAlign.center,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                ),
              ),
            ],
          ),
        ),
        // This is a default 72 pixels indent
        const SizedBox(height: 72),
        // This is an additional option to fill the screen if screen
        // is large enough
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the URL of your project host',
                style: AppTextStyles.large.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You can copy the URL link of the website of your OpenProject from the browser, and paste it here.',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                ),
              ),
              const SizedBox(height: 24),
              AppTextFormField(
                hint: 'URL Link',
                controller:
                    context.read<AuthController>().serverUrlTextController,
                disableLabel: true,
                contentPadding: const EdgeInsets.only(top: 18, bottom: 18),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    right: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.border,
                    ),
                    child: Text(
                      'https://',
                      style: AppTextStyles.small.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.highContrastCursor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthPingServerCubit,
                  AsyncValue<void, NetworkFailure>>(
                builder: (context, state) {
                  return AppButton(
                    text: 'Connect to Server',
                    loading: state.isLoading,
                    onPressed: () {
                      context.read<AuthController>().pingServer();
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

/*
class _ServerInputScreen extends StatefulWidget {
  final void Function() navigateToNextPageHandler;
  const _ServerInputScreen({
    required this.navigateToNextPageHandler,
  });

  @override
  State<StatefulWidget> createState() => Server();
}

ButtonStyle buttonServer() {
  ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    elevation: 10,
    minimumSize: const Size(360, 50),
    padding: const EdgeInsets.symmetric(horizontal: 35),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
  );

  return raisedButtonStyle;
}

class Server extends State<_ServerInputScreen> {
  String? error;
  var server = "";
  TextEditingController enteredServer = TextEditingController();
  ProcessingServer ser = ProcessingServer();

  @override
  void initState() {
    super.initState();
    enteredServer.text = "https://";
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double? circleSize = screenSize.width;

    return Column(
      children: [
        Image(
          image: const AssetImage('assets/images/Server.png'),
          width: circleSize,
          height: screenSize.height * 0.4,
          fit: BoxFit.contain,
        ),
        const Text(
          "Your projects, One link away",
          style: TextStyle(
              fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            "Enter the server URL to connect with your team’s workspace and access your ongoing projects.",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Enter the URL of your project host",
          style: TextStyle(
              fontSize: 23, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            "You can copy the URL link of the website of your OpenProject from the browser, and paste it here.",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
          child: TextField(
            controller: enteredServer,
            maxLines: 1,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Enter Server",
              errorText: error,
            ),
            onChanged: (value) {
              server = value;
            },
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: 350.0,
          child: ElevatedButton(
            style: buttonServer(),
            onPressed: () {
              if (server.isEmpty || enteredServer.text.isEmpty) {
                error = "Please enter a valid server URL.";
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    duration: Duration(milliseconds: 500),
                    content: Text(
                      "Failure :(",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                );
                setState(() {});
                return;
              } else if (enteredServer.text.trim().startsWith("http://")) {
                error = "Please enter a valid server URL starting with https.";
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(milliseconds: 500),
                    content: Text(
                      "Failure :(",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                );
                setState(() {});
                return;
              } else {
                error = null;
                ser.getServer(enteredServer.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    duration: Duration(milliseconds: 500),
                    content: Text(
                      "Connected :)",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                );
                widget.navigateToNextPageHandler();
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const GetToken(),
                //   ),
                // );
              }
            },
            child: const Text(
              "Connect to Server",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
*/
