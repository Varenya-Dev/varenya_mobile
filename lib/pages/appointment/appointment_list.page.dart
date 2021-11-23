import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/appointments/patient_appointment_response/patient_appointment_response.model.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/utils/snackbar.dart';
import 'package:varenya_mobile/widgets/appointments/appointment_card.widget.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  static const routeName = "/appointments-list";

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  late final AppointmentService _appointmentService;

  List<PatientAppointmentResponse> _appointments = [];

  @override
  void initState() {
    super.initState();

    this._appointmentService =
        Provider.of<AppointmentService>(context, listen: false);
  }

  void _refreshAppointmentLists() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Appointments'),
      ),
      body: FutureBuilder(
        future: this._appointmentService.fetchScheduledAppointments(),
        builder: (
          BuildContext buildContext,
          AsyncSnapshot<List<PatientAppointmentResponse>> snapshot,
        ) {
          if (snapshot.hasError) {
            switch (snapshot.error.runtimeType) {
              case ServerException:
                {
                  ServerException exception = snapshot.error as ServerException;
                  return Text(exception.message);
                }
              default:
                {
                  return Text("Something went wrong, please try again later");
                }
            }
          }

          if (snapshot.connectionState == ConnectionState.done) {
            this._appointments = snapshot.data!;
            return ListView.builder(
              itemCount: this._appointments.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                PatientAppointmentResponse appointmentResponse =
                    this._appointments[index];

                return AppointmentCard(
                  appointment: appointmentResponse,
                  refreshAppointments: this._refreshAppointmentLists,
                );
              },
            );
          }

          return Column(
            children: [
              CircularProgressIndicator(),
            ],
          );
        },
      ),
    );
  }
}
