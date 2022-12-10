class UserInformationUtils {
  const UserInformationUtils._privateConsrtructor();

  static const UserInformationUtils _instance =
      UserInformationUtils._privateConsrtructor();
  static UserInformationUtils get instance => _instance;

  String formatFullName(String firstName, String middleName, String lastName) {
    String result = '';
    result = '$lastName $middleName $firstName';
    return result;
  }
}
