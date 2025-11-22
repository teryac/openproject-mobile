import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/auth/application/auth_controller.dart';
import 'package:open_project/auth/models/user.dart';
import 'package:open_project/auth/presentation/cubits/auth_get_user_cubit.dart';
import 'package:open_project/auth/presentation/widgets/token_input_screen/api_token_instructions_dialog.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/app_image.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/blurred_overlays.dart';

class TokenInputScreen extends StatelessWidget {
  const TokenInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding:
              EdgeInsets.only(bottom: 32.0, left: 20.0, right: 20.0, top: 20.0),
          child: AppAssetImage(
            assetPath: AppImages.overview,
            height: 217.0,
            fit: BoxFit.fitHeight,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                'Step into your workspace',
                textAlign: TextAlign.center,
                style: AppTextStyles.extraLarge.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your API token to edit tasks, access private projects, and collaborate with your team.',
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
                'Enter Your API token',
                style: AppTextStyles.large.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'To get your API token, go to account settings on the website. For help, see the guide below.',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                ),
              ),
              const SizedBox(height: 24),
              AppTextFormField(
                hint: 'API Token',
                controller: context.read<AuthController>().tokenTextController,
                obscure: true,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: AppTextButton(
                  text: 'How to get API token?',
                  onPressed: () {
                    showBlurredDialog(
                      context: context,
                      builder: (_) {
                        return const ApiTokenInstructionsDialog();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthGetUserCubit, AsyncValue<User, NetworkFailure>>(
                builder: (context, state) {
                  return AppButton(
                    text: 'Access Workspace',
                    loading: state.isLoading,
                    onPressed: context.read<AuthController>().getUserData,
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

/*class TempTokenScreem extends StatefulWidget {
  const TempTokenScreem({super.key});

  @override
  State<StatefulWidget> createState() => Token();
}

ButtonStyle buttonToken() {
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

class Token extends State<TempTokenScreem> {
  TextEditingController enteredToken = TextEditingController();
  String? error;
  ProcessingToken token = ProcessingToken();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double? circleSize = screenSize.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 19.0),
          child: Row(
            children: [
              Image(
                image: const AssetImage(AppImages.list),
                width: circleSize * 0.42,
                height: screenSize.height * 0.4,
              ),
              SizedBox(width: circleSize * 0.03),
              Image(
                image: const AssetImage(AppImages.user),
                width: circleSize * 0.5,
                height: screenSize.height * 0.4,
              ),
            ],
          ),
        ),
        const Text(
          "Step into your workspace",
          style: TextStyle(
              fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            textAlign: TextAlign.center,
            "Enter your API token to edit tasks, access private projects, and collaborate with your team.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 15),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Enter Your API token",
              style: TextStyle(
                fontSize: 23,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            textAlign: TextAlign.left,
            "To get your API token, go to account settings on the website. For help, see the guide below.",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: TextField(
            controller: enteredToken,
            //maxLines: 2,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "API Token",
              errorText: error,
            ),
            onChanged: (value) {
              enteredToken.text = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 24, right: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: AppTextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Colors.white,
                      child: SingleChildScrollView(
                        //height: screenSize.height * 0.5,
                        //width: screenSize.width * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "How to get API tokens?",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                              const Image(
                                image: AssetImage('assets/images/token.png'),
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    "Accessing Account Settings",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "To begin, navigate to the website and click on the profile icon. Next, select the 'My Account' tab as illustrated in the image above.Next, select the 'Access tokens' tab.",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
               // );
              },
              text: 'How to get API tokens?',
            ),
          ),
        ),
        SizedBox(
          width: 350.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 10,
              minimumSize: const Size(360, 50),
              padding: const EdgeInsets.symmetric(horizontal: 35),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            onPressed: () {
              if (enteredToken.text.isNotEmpty) {
                token.checkToken(enteredToken.text);
                enteredToken.text = "";
                error = null;
                context.goNamed(AppRoutes.home.name);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const ShowScreen(),
                //   ),
                // );
                setState(() {});
              } else {
                error = "Enter API Token.";
                //Navigator.pop(context);
                setState(() {});
                return;
              }
            },
            child: const Text(
              "Access workspace",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
*/
