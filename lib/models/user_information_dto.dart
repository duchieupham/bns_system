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

  final String address;

  const UserInformationDTO({
    required this.userId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.phoneNo,
    required this.address,
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
      address: json['address'] ?? '',
    );
  }
  Map<String, dynamic> toSPJson() {
    final Map<String, dynamic> data = {};
    data['"firstName"'] = (firstName == '') ? '""' : '"$firstName"';
    data['"middleName"'] = (middleName == '') ? '""' : '"$middleName"';
    data['"lastName"'] = (lastName == '') ? '""' : '"$lastName"';
    data['"birthDate"'] = (birthDate == '') ? '""' : '"$birthDate"';
    data['"gender"'] = (gender == '') ? '""' : '"$gender"';
    data['"phoneNo"'] = (phoneNo == '') ? '""' : '"$phoneNo"';
    data['"address"'] = (address == '') ? '""' : '"$address"';
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['id'] = userId;
    data['address'] = address;
    data['birthDate'] = birthDate;
    data['phoneNo'] = phoneNo;
    data['gender'] = (gender == 'true');
    return data;
  }
}
