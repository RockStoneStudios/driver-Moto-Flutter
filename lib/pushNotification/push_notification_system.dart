import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driversapp/global/global_var.dart';
import 'package:driversapp/models/trip_details.dart';
import 'package:driversapp/widgets/loading_dialogs.dart';
import 'package:driversapp/widgets/notification_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PushNotificationSystem {
  FirebaseMessaging firebaseCloudMessaging = FirebaseMessaging.instance;

  Future<String?> generateDeviceRegistrationToken() async {
    String? deviceRecognitionToken = await firebaseCloudMessaging.getToken();

    DatabaseReference referenceOnlineDriver = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("deviceToken");

    referenceOnlineDriver.set(deviceRecognitionToken);

    firebaseCloudMessaging.subscribeToTopic("drivers");
    firebaseCloudMessaging.subscribeToTopic("users");
  }

  startListeningForNewNotification(BuildContext context) async {
    ///1. Terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        String tripID = messageRemote.data["tripID"];
        retrieveTripRequestInfo(tripID, context);
      }
    });

    ///2. Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        String tripID = messageRemote.data["tripID"];
        retrieveTripRequestInfo(tripID, context);
      }
    });

    ///3. Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        String tripID = messageRemote.data["tripID"];
        retrieveTripRequestInfo(tripID, context);
      }
    });
  }

  void retrieveTripRequestInfo(String tripID, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Getting details..."),
    );

    DatabaseReference tripRequestsRef = FirebaseDatabase.instance.ref().child("tripRequests").child(tripID);

    tripRequestsRef.once().then((dataSnapshot) {
      Navigator.pop(context); // Cierra el diálogo de carga

      if (dataSnapshot.snapshot.value != null) {
        print("MyApp - Full DataSnapshot Received: ${dataSnapshot.snapshot.value}"); // Imprime el snapshot completo

        final dynamic snapshotValue = dataSnapshot.snapshot.value;
        if (snapshotValue is Map) {
          Map<String, dynamic> tripData = {};
          snapshotValue.forEach((key, value) {
            if (value is Map) {
              // Es necesario para manejar los datos anidados como dropOffLatLng y pickUpLatLng
              Map<String, dynamic> nestedData = {};
              value.forEach((nestedKey, nestedValue) {
                nestedData[nestedKey.toString()] = nestedValue;
              });
              tripData[key.toString()] = nestedData;
            } else {
              tripData[key.toString()] = value;
            }
          });

          try {
            // Creación de la instancia de TripDetails usando fromJson
            TripDetails tripDetailsInfo = TripDetails.fromJson(tripData);

            print("MyApp - Trip Details Retrieved: ${tripDetailsInfo.toJson()}");

            audioPlayer.open(Audio("assets/audio/alert_sound.mp3"));
            audioPlayer.play();

            showDialog(
              context: context,
              builder: (BuildContext context) => NotificationDialog(
                tripDetailsInfo: tripDetailsInfo,
              ),
            );
          } catch (e) {
            print("MyApp - Error processing trip data: $e");
          }
        } else {
          print("MyApp - DataSnapshot is not a Map.");
        }
      } else {
        print("MyApp - No trip data available for tripID: $tripID");
      }
    }).catchError((error) {
      print("MyApp - Error retrieving trip request: $error");
      Navigator.pop(context);
    });
  }
}
