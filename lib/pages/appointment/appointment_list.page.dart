import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';
import 'package:varenya_mobile/services/appointment.service.dart';
import 'package:varenya_mobile/utils/logger.util.dart';
import 'package:varenya_mobile/widgets/appointments/appointment_card.widget.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  // Page Route Name
  static const routeName = "/appointments-list";

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  // Appointment Service.
  late final AppointmentService _appointmentService;

  // List of appointments.
  List<Appointment>? _appointments;

  @override
  void initState() {
    super.initState();

    // Inject appointment service from the global state.
    this._appointmentService =
        Provider.of<AppointmentService>(context, listen: false);
  }

  /*
   * Method to refresh appointments page.
   */
  void _refreshAppointmentLists() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Appointments'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: this._appointmentService.fetchScheduledAppointments(),
          builder: _handleAppointmentsFuture,
        ),
      ),
    );
  }

  /*
   * Method to consume future and display appointments body.
   */
  Widget _handleAppointmentsFuture(
    BuildContext buildContext,
    AsyncSnapshot<List<Appointment>> snapshot,
  ) {
    // Check for errors.
    if (snapshot.hasError) {
      // Checking type of error and handling them.
      switch (snapshot.error.runtimeType) {
        case ServerException:
          {
            ServerException exception = snapshot.error as ServerException;
            return Text(exception.message);
          }
        default:
          {
            log.e(
              "AppointmentList Error",
              snapshot.error,
              snapshot.stackTrace,
            );
            return Text("Something went wrong, please try again later");
          }
      }
    }

    // Check if data has been loaded
    if (snapshot.connectionState == ConnectionState.done) {
      this._appointments = snapshot.data!;

      // Return and build main page.
      return _buildAppointmentsBody();
    }

    // If previously fetched appointments exists,
    // display them or loading indicator.
    return this._appointments == null
        ? Column(
            children: [
              CircularProgressIndicator(),
            ],
          )
        : this._buildAppointmentsBody();
  }

  /*
   * Method to build page based on appointments data.
   */
  Widget _buildAppointmentsBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: this._appointments!.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          Appointment appointmentResponse = this._appointments![index];

          return AppointmentCard(
            appointment: appointmentResponse,
            refreshAppointments: this._refreshAppointmentLists,
          );
        },
      ),
    );
  }
}
