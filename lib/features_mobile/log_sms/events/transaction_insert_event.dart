import 'package:equatable/equatable.dart';

class TransactionInsertEvent extends Equatable {
  const TransactionInsertEvent();

  @override
  List<Object?> get props => [];
}

//To get list SMS that read from Android phone
class TransactionInsertEventGetList extends TransactionInsertEvent {}

//To listen new SMS from Android phone
class TransactionInsertEventListenSMS extends TransactionInsertEvent {}

//To insert data into Firestore
class TransactionInsertEventInsertToDb extends TransactionInsertEvent {}
