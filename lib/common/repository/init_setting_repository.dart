import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitSettingRepository{
  static Future<void> init()async {
    await initNotification();
  }


  static Future<void> putToken() async{
    final fcmToken = await FirebaseMessaging.instance.getToken();

    var document = FirebaseFirestore.instance
        .collection('fcmToken');
    await document.doc(fcmToken.toString()).set({'token':fcmToken.toString()});
  }
  static Future<void> delToken() async{
    final fcmToken = await FirebaseMessaging.instance.getToken();

    var document = FirebaseFirestore.instance
        .collection('fcmToken');
    await document.doc(fcmToken.toString()).delete();
  }

  static  Future<void> initNotification() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

  }


}