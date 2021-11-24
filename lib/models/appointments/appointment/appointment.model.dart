import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_mobile/enum/confirmation_status.enum.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';

part 'appointment.model.g.dart';

@JsonSerializable()
class Appointment {
  String id;
  DateTime scheduledFor;
  DateTime createdAt;
  DateTime updatedAt;
  ConfirmationStatus status;
  ServerUser patientUser;
  ServerUser doctorUser;

  Appointment({
    required this.id,
    required this.scheduledFor,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.patientUser,
    required this.doctorUser,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}