class UserInformationDTO {
  final String userId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String birthDate;
  //true = man
  //false = women;
  final String gender;
  final String phoneNo;

  const UserInformationDTO({
    required this.userId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.phoneNo,
  });

  factory UserInformationDTO.fromJson(Map<String, dynamic> json) {
    return UserInformationDTO(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      birthDate: json['birthDate'] ?? '',
      gender: json['gender'] ?? 'false',
      phoneNo: json['phoneNo'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['"firstName"'] = (firstName == '') ? '""' : '"$firstName"';
    data['"middleName"'] = (middleName == '') ? '""' : '"$middleName"';
    data['"lastName"'] = (lastName == '') ? '""' : '"$lastName"';
    data['"birthDate"'] = (birthDate == '') ? '""' : '"$birthDate"';
    data['"gender"'] = (gender == '') ? '""' : '"$gender"';
    data['"phoneNo"'] = (phoneNo == '') ? '""' : '"$phoneNo"';
    return data;
  }
}
