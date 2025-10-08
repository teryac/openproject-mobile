class AppIcons {
  static const _directory = 'assets/icons/';
  static const _fileType = '.svg';

  static const logo = '${_directory}logo$_fileType';
  static const task = '${_directory}task$_fileType';
  static const trash = '${_directory}trash$_fileType';
  static const edit = '${_directory}edit$_fileType';
  static const search = '${_directory}search$_fileType';
  static const arrowUp = '${_directory}arrow-up$_fileType';
  static const arrowRight = '${_directory}arrow-right$_fileType';
  static const arrowLeft = '${_directory}arrow-left$_fileType';
  static const closeSquare = '${_directory}close-square$_fileType';
  static const link = '${_directory}link$_fileType';
  static const logoWithName = '${_directory}logo-with-name$_fileType';
}

class AppImages {
  static const _directory = 'assets/images/';
  static const _fileType = '.png';

  static const emp = '${_directory}emp$_fileType';
  static const list = '${_directory}list$_fileType';
  static const op = '${_directory}op$_fileType';
  static const openProject = '${_directory}openproject$_fileType';
  static const server = '${_directory}Server$_fileType';
  static const token = '${_directory}token$_fileType';
  static const user = '${_directory}user$_fileType';
  static const profile = '${_directory}profile$_fileType';
  static const globe = '${_directory}globe$_fileType';

  //logo-with-name.svg
  static String howToGetApiToken(int index) {
    return '${_directory}how_to_get_api_token_$index$_fileType';
  }
}
