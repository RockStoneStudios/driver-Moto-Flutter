// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripDetails _$TripDetailsFromJson(Map<String, dynamic> json) => TripDetails(
      tripID: json['tripID'] as String?,
      pickUpLatLng: TripDetails.latLngFromJson(
          json['pickUpLatLng'] as Map<String, dynamic>?),
      dropOffLatLng: TripDetails.latLngFromJson(
          json['dropOffLatLng'] as Map<String, dynamic>?),
      dropOffAddress: json['dropOffAddress'] as String?,
      userName: json['userName'] as String?,
      userPhone: json['userPhone'] as String?,
    );

Map<String, dynamic> _$TripDetailsToJson(TripDetails instance) =>
    <String, dynamic>{
      'tripID': instance.tripID,
      'pickUpLatLng': TripDetails.latLngToJson(instance.pickUpLatLng),
      'dropOffLatLng': TripDetails.latLngToJson(instance.dropOffLatLng),
      'dropOffAddress': instance.dropOffAddress,
      'userName': instance.userName,
      'userPhone': instance.userPhone,
    };
