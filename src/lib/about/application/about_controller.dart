import 'package:open_project/about/data/about_repo.dart';
import 'package:open_project/about/models/version.dart';

class AboutController {
  final AboutRepo _aboutRepo;

  AboutController({required AboutRepo aboutRepo}) : _aboutRepo = aboutRepo;

  String getCopyRights() => _aboutRepo.getCopyRights();
  String getDataSafety() => _aboutRepo.getDataSafety();
  String getFeedback() => _aboutRepo.getFeedback();
  List<Version> getVersions() => _aboutRepo.getVersions();
}
