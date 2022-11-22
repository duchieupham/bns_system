class StringUtils {
  const StringUtils._privateConsrtructor();

  static const StringUtils _instance = StringUtils._privateConsrtructor();
  static StringUtils get instance => _instance;

  bool isNumeric(String text) {
    return int.tryParse(text) != null;
  }
}
