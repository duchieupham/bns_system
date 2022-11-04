class VietQRGenerateDTO {
  //Consumer Account Information Value
  final String cAIValue;
  //Transaction Amount length and value
  final String transactionAmountLength;
  final String transactionAmountValue;
  //Additional Data Field Template length and value
  final String additionalDataFieldTemplateLength;
  final String additionalDataFieldTemplateValue;
  //CRC (Cyclic Redundancy Check) value;
  final String crcValue;

  const VietQRGenerateDTO({
    required this.cAIValue,
    required this.transactionAmountLength,
    required this.transactionAmountValue,
    required this.additionalDataFieldTemplateLength,
    required this.additionalDataFieldTemplateValue,
    required this.crcValue,
  });
}
