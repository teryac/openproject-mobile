import 'package:open_project/about/models/version.dart';

class AboutRepo {
  String getCopyRights() {
    return """**This application is proud to be open source. We believe in transparency and community collaboration.**

**You can view our source code, contribute, or audit our security on GitHub.**

• **Integration:** This client connects (unofficially) with [OpenProject.org](https://www.openproject.org).

• **GitHub Repository:** [github.com/teryac/openproject-mobile](https://github.com/teryac/openproject-mobile)""";
  }

  String getDataSafety() {
    return """**Your data belongs to you. We take security seriously.**

• **Local Storage:** Your OpenProject access tokens and credentials are encrypted and stored locally on your device. They are never uploaded to our servers or any third-party storage.

• **Direct Communication:** The app communicates directly with your specified OpenProject instance.
• **Verification:** Because we are open source, you are welcome to [inspect our source code](https://github.com/teryac/openproject-mobile) at any time to verify these claims.""";
  }

  String getFeedback() {
    return """**Have a feature request or found a bug? We’d love to hear from you.**

• [Open an issue](https://github.com/teryac/openproject-mobile/issues)""";
  }

  List<Version> getVersions() {
    return [
      Version(
        name: '1.0.0',
        changeLog: [
          '**Initial Release:** Welcome to the first version of the OpenProject client',
          '**Security:** Support for secure API Token authentication with local-only storage',
          '**Work Packages:** View and track your work packages on the go',
          '**Performance:** Optimized for fast loading and offline viewing of cached data',
          '**Open Source:** The app is officially open to community contributions',
        ],
      ),
    ];
  }
}
