import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/features_mobile/log_sms/blocs/transaction_bloc.dart';
import 'package:vierqr/features_mobile/notification/events/notification_event.dart';
import 'package:vierqr/features_mobile/notification/repositories/notification_repository.dart';
import 'package:vierqr/features_mobile/notification/states/notification_state.dart';
import 'package:vierqr/features_mobile/personal/repositories/member_manage_repository.dart';
import 'package:vierqr/models/transaction_dto.dart';
import 'package:vierqr/models/notification_dto.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationInitialState()) {
    on<NotificationEventInsert>(_insertNotifications);
    on<NotificationEventListen>(_listenNewNotification);
    on<NotificationEventReceived>(_receivedNewNotification);
    on<NotificationEventUpdateStatus>(_updateStatusNotification);
    on<NotificationEventUpdateAllStatus>(_updateStatusNotifications);
    on<NotificationEventGetList>(_getNotifications);
  }
}

const MemberManageRepository memberManageRepository = MemberManageRepository();
const NotificationRepository notificationRepository = NotificationRepository();

void _insertNotifications(NotificationEvent event, Emitter emit) async {
  try {
    if (event is NotificationEventInsert) {
      List<String> userIds =
          await memberManageRepository.getUserIdsByBankId(event.bankId);
      const Uuid uuid = Uuid();
      if (userIds.isNotEmpty) {
        for (String userId in userIds) {
          NotificationDTO notificationDTO = NotificationDTO(
            id: uuid.v1(),
            transactionId: event.transactionId,
            userId: userId,
            type: Stringify.NOTIFICATION_TYPE_TRANSACTION,
            message:
                'Giao dịch đến tài khoản ${event.address}. Số tiền ${event.transaction}',
            timeInserted: event.timeInserted,
            isRead: false,
          );
          await notificationRepository.insertNotification(notificationDTO);
        }
      }
    }
  } catch (e) {
    print('Error at _insertNotifications - NotificationBloc: $e');
    emit(const NotificationFailedInsertState());
  }
}

void _listenNewNotification(NotificationEvent event, Emitter emit) {
  try {
    if (event is NotificationEventListen) {
      notificationRepository.listenNewNotification(event.userId);
      NotificationRepository.notificationController.listen((notificationDTO) {
        if (notificationDTO.type == Stringify.NOTIFICATION_TYPE_TRANSACTION) {
          event.notificationBloc
              .add(NotificationEventReceived(notificationDTO: notificationDTO));
        }
      });
    }
  } catch (e) {
    print('Error at _listenNewNotification - NotificationBloc: $e');
    emit(const NotificationFailedInsertState());
  }
}

void _receivedNewNotification(NotificationEvent event, Emitter emit) async {
  try {
    if (event is NotificationEventReceived) {
      final TransactionDTO transactionDTO = await transactionRepository
          .getTransactionById(event.notificationDTO.transactionId);
      if (transactionDTO.id.isNotEmpty) {
        emit(NotificationReceivedSuccessState(
          transactionDTO: transactionDTO,
          notificationId: event.notificationDTO.id,
        ));
      }
    }
  } catch (e) {
    print('Error at _receivedNewNotification - NotificationBloc: $e');
    emit(const NotificationReceivedFailedState());
  }
}

void _updateStatusNotification(NotificationEvent event, Emitter emit) async {
  try {
    if (event is NotificationEventUpdateStatus) {
      await notificationRepository
          .updateStatusNotification(event.notificationId);
      emit(const NotificationUpdateSuccessState());
    }
  } catch (e) {
    print('Error at _updateStatusNotification - NotificationBloc: $e');
    emit(const NotificationUpdateFailedState());
  }
}

void _updateStatusNotifications(NotificationEvent event, Emitter emit) async {
  try {
    if (event is NotificationEventUpdateAllStatus) {
      await notificationRepository
          .updateStatusNotifications(event.notificationIds);
      emit(const NotificationsUpdateSuccessState());
    }
  } catch (e) {
    print('Error at _updateStatusNotifications - NotificationBloc: $e');
    emit(const NotificationsUpdateFailedState());
  }
}

void _getNotifications(NotificationEvent event, Emitter emit) async {
  try {
    if (event is NotificationEventGetList) {
      List<NotificationDTO> list =
          await notificationRepository.getNotifications(event.userId);
      emit(NotificationListSuccessfulState(list: list));
    }
  } catch (e) {
    print('Error at _getNotifications - NotificationBloc: $e');
    emit(const NotificationListFailedState());
  }
}
