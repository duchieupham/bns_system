import 'package:check_sms/commons/enums/bank_name.dart';
import 'package:check_sms/models/bank_information_dto.dart';

class SmsInformationUtils {
  const SmsInformationUtils._privateConsrtructor();

  static const SmsInformationUtils _instance =
      SmsInformationUtils._privateConsrtructor();
  static SmsInformationUtils get instance => _instance;

  //transfer sms data to information
  BankInformationDTO transferSmsData(String bankName, String body) {
    print('bank name: $bankName');
    BankInformationDTO result = const BankInformationDTO(
        address: '',
        time: '',
        transaction: '',
        accountBalance: '',
        content: '',
        bankAccount: '');
    //Viettin Bank
    if (bankName == BANKNAME.VIETTINBANK.toString()) {
      List<String> data = body.split('|');
      print('data: $data');
      //having 5 components

      String time =
          '${data[0].trim().split(':')[1]}:${data[0].trim().split(':')[2]}';
      String bankAccount = data[1].trim().split(':')[1];
      String transaction = data[2].trim().split(':')[1];
      transaction = transaction.replaceAll('V', ' V');
      String accountBalance = data[3].trim().split(':')[1];
      accountBalance = accountBalance.replaceAll('V', ' V');
      String content = data[4].trim().substring(3);
      content = content.substring(0, content.length - 1);
      result = BankInformationDTO(
        address: bankName.replaceAll('BANKNAME.', ''),
        time: time,
        transaction: transaction,
        accountBalance: accountBalance,
        content: content,
        bankAccount: bankAccount,
      );
    }
    //SHB
    if (bankName == BANKNAME.SHB.toString()) {
      String time = body.split('den')[1].split('la')[0];
      String bankAccount = body.split('SDTK ')[1].split(' den')[0];
      String transaction =
          body.split('GD moi nhat: ')[1].split('VND:')[0] + 'VND';
      String accountBalance = body.split('la ')[1].split('VND.')[0] + 'VND';
      String content = body.split('VND:')[1].trim();
      result = BankInformationDTO(
        address: bankName.replaceAll('BANKNAME.', ''),
        time: time,
        transaction: transaction,
        accountBalance: accountBalance,
        content: content,
        bankAccount: bankAccount,
      );
    }
    return result;
  }
}
