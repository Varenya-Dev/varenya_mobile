import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/enum/job.enum.dart';
import 'package:varenya_mobile/enum/specialization.enum.dart';
import 'package:varenya_mobile/models/doctor/doctor.model.dart';
import 'package:varenya_mobile/services/doctor.service.dart';
import 'package:varenya_mobile/utils/modal_bottom_sheet.dart';
import 'package:varenya_mobile/widgets/doctor/doctor_card.widget.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({Key? key}) : super(key: key);

  static const routeName = "/doctor-list";

  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  late final DoctorService _doctorService;

  Job? _jobFilter;
  List<Specialization> _specializationsFilter = [];
  List<Doctor> _doctors = [];

  @override
  void initState() {
    super.initState();

    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  void _openSpecializationFilters(BuildContext context) {
    displayBottomSheet(
      context,
      StatefulBuilder(
        builder: (context, setStateInner) => Wrap(
          children: [
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: Specialization.values
                  .map(
                    (s) => ListTile(
                      title: Text(
                        s.toString().split(".")[1],
                      ),
                      leading: Checkbox(
                        value: this._specializationsFilter.contains(s),
                        onChanged: (bool? value) {
                          if (value == true) {
                            setState(() {
                              this._specializationsFilter.add(s);
                            });
                          } else {
                            setState(() {
                              this._specializationsFilter.remove(s);
                            });
                          }
                          setStateInner(() {});
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
            Center(
              child: TextButton(
                child: Text('Clear Filters'),
                onPressed: () {
                  setState(() {
                    this._specializationsFilter.clear();
                  });

                  setStateInner(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openJobFilters(BuildContext context) {
    displayBottomSheet(
      context,
      StatefulBuilder(
        builder: (context, setStateInner) => Wrap(
          children: [
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: Job.values
                  .map(
                    (job) => ListTile(
                      title: Text(
                        job.toString().split(".")[1],
                      ),
                      leading: Radio(
                        value: job,
                        groupValue: this._jobFilter,
                        onChanged: (Job? jobValue) {
                          if (jobValue != null) {
                            setState(() {
                              this._jobFilter = jobValue;
                            });

                            setStateInner(() {});
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
            Center(
              child: TextButton(
                child: Text('Clear Filters'),
                onPressed: () {
                  setState(() {
                    this._jobFilter = null;
                  });

                  setStateInner(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors'),
      ),
      body: Column(
        children: [
          _buildFilterMain(),
          StreamBuilder(
            stream: this
                ._doctorService
                .fetchDoctorsStream(_jobFilter, _specializationsFilter),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              }

              this._doctors = snapshot.data!.docs
                  .map((data) => Doctor.fromJson(data.data()))
                  .toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: this._doctors.length,
                itemBuilder: (BuildContext context, int index) {
                  Doctor doctor = this._doctors[index];

                  return DoctorCard(
                    doctor: doctor,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterMain() {
    return ExpandableNotifier(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Text(
                    "Filter Options",
                  ),
                ),
                collapsed: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 20.0,
                  ),
                  child: Text(
                    "Tap To Show Filter Options",
                  ),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildJobFilter(),
                    _buildSpecializationFilter(),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(
                      crossFadePoint: 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecializationFilter() {
    return ListTile(
      title: Text('Select Specialization Filter'),
      onTap: () {
        this._openSpecializationFilters(context);
      },
    );
  }

  Widget _buildJobFilter() {
    return ListTile(
      title: Text('Select Job Filter'),
      onTap: () {
        this._openJobFilters(context);
      },
    );
  }
}
