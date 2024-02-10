import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trip_details.g.dart';

@JsonSerializable(explicitToJson: true)
class TripDetails {
  String? tripID;

  @JsonKey(fromJson: latLngFromJson, toJson: latLngToJson)
  LatLng? pickUpLatLng;

  @JsonKey(fromJson: latLngFromJson, toJson: latLngToJson)
  LatLng? dropOffLatLng;
  String? dropOffAddress;

  String? userName;
  String? userPhone;

  TripDetails({
    this.tripID,
    this.pickUpLatLng,
    this.dropOffLatLng,
    this.dropOffAddress,
    this.userName,
    this.userPhone,
  });

  factory TripDetails.fromJson(Map<String, dynamic> json) => _$TripDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$TripDetailsToJson(this);

  static LatLng latLngFromJson(Map<String, dynamic>? json) {
    return LatLng(
      double.parse(json?['latitude'] ?? '0'),
      double.parse(json?['longitude'] ?? '0'),
    );
  }

  static Map<String, dynamic> latLngToJson(LatLng? latLng) => {
    'latitude': latLng?.latitude.toString(),
    'longitude': latLng?.longitude.toString(),
  };
}
