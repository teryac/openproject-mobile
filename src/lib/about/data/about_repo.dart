import 'package:open_project/about/models/version.dart';

class AboutRepo {
  String getProjectInfo() {
    return """**This is an open-source mobile client for OpenProject. This project is not affiliated with, maintained, or endorsed by the official [OpenProject](https://www.openproject.org) team.**

**You can view the source code, contribute, or audit our security on GitHub.**

• **Compatibility:** This client connects to your self-hosted or cloud OpenProject instance via the official API.

• **GitHub Repository:** [github.com/teryac/client-for-openproject](https://github.com/teryac/client-for-openproject)""";
  }

  String getDataSafety() {
    return """**Your data remains in your device.**

• **Local Storage:** Your OpenProject URL and API tokens are encrypted and stored locally on your device. They are never uploaded to our servers or any third-party storage.

• **Direct Communication:** The app communicates directly with your specified OpenProject instance using the official OpenProject APIs.

• **Crash Reporting:** This app uses Firebase Crashlytics to report anonymous crash data. No OpenProject content is included in these reports.

• **Transparency:** You can audit our data handling and security practices directly in the [Github repo](https://github.com/teryac/client-for-openproject)""";
  }

  String getFeedback() {
    return """**Have a feature request or found a bug? We’d love to hear from you.**

• [Open an issue](https://github.com/teryac/client-for-openproject/issues)""";
  }

  List<Version> getVersions() {
    return [
      Version(
        name: '1.0.0',
        changeLog: [
          '**Initial release**',
        ],
      ),
    ];
  }
}
