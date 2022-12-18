import 'package:rxdart/rxdart.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/models/notification_dto.dart';
import 'package:vierqr/services/firestore/notification_db.dart';

class NotificationRepository {
  static final notificationController = BehaviorSubject<NotificationDTO>();

  const NotificationRepository();

  //step 3
  Future<void> insertNotification(NotificationDTO notificationDTO) async {
    try {
      await NotificationDB.instance.insertNotification(notificationDTO);
    } catch (e) {
      print('Error at insertNotification - NotificationRepository: $e');
    }
  }

  //step 4
  void listenNewNotification(String userId) {
    try {
      NotificationDB.instance.listenNotification(userId).listen((data) {
        if (data.docs.isNotEmpty) {
          //check time range here, before sink add
          //do not need to using for loop, because list is sorted by time.
          if (TimeUtils.instance
              .checkValidTimeRange(data.docs.first['timeCreated'], 30)) {
            NotificationDTO notificationDTO = NotificationDTO(
              id: data.docs.first['id'],
              transactionId: data.docs.first['transactionId'],
              userId: data.docs.first['userId'],
              message: data.docs.first['message'],
              type: data.docs.first['type'],
              timeInserted: data.docs.first['timeCreated'],
              isRead: data.docs.first['isRead'],
            );
            notificationController.sink.add(notificationDTO);
          }
        }
      });
    } catch (e) {
      print('Error at listenNewNotification - NotificationRepository: $e');
    }
  }

  //step 4
  Future<void> updateStatusNotification(String id) async {
    try {
      await NotificationDB.instance.updateNotification(id);
    } catch (e) {
      print('Error at updateStatusNotification - NotificationRepository: $e');
    }
  }

  //step 4 - update when click into icon notification
  Future<void> updateStatusNotifications(List<String> ids) async {
    try {
      for (String id in ids) {
        await NotificationDB.instance.updateNotification(id);
      }
    } catch (e) {
      print('Error at updateStatusNotifications - NotificationRepository: $e');
    }
  }

  //step 5
  Future<List<NotificationDTO>> getNotifications(String userId) async {
    List<NotificationDTO> result = [];
    try {
      result = await NotificationDB.instance.getNotificationByUserId(userId);
    } catch (e) {
      print('Error at getNotifications - NotificationRepository: $e');
    }
    return result;
  }
}
