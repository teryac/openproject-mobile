class AppConstants {
  static const serverUrlCacheKey = 'server_url';
  static const apiTokenCacheKey = 'api_token';
  static const userIdCacheKey = 'user_id';
  static const userNameCacheKey = 'user_name';
  static const userFirstNameCacheKey = 'user_first_name';
  static const userEmailCacheKey = 'user_email';

  static ({String title, String body}) getApiTokenInstructions(int index) {
    switch (index) {
      case 0:
        return (
          title: 'Accessing Account Settings',
          body:
              'To begin, navigate to the website and click on the profile icon. Next, select the \'My Account\' tab as illustrated in the image above.'
        );
      case 1:
        return (
          title: 'Accessing Settings Drawer',
          body:
              'Then, click on the drawer icon at the top left corner, and click on \'Access tokens\' option from the drawer menu.'
        );
      case 2:
        return (
          title: 'Generating a token',
          body:
              'Finally, click the button \'+ API token\' to generate an access token, once done, copy it and paste it in the app.'
        );
      default:
        throw Exception('API Token Instruction index must be 0-2');
    }
  }
}
