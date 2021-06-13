import 'package:flutter/material.dart';
import 'package:karetaker/constants/strings.dart';
import 'package:karetaker/data/models/pills.dart';
import 'package:karetaker/data/models/user.dart';
import 'package:karetaker/data/repositories/pills_repo.dart';
import 'package:karetaker/presentation/nav/graphs.dart';
import 'package:karetaker/presentation/nav/reports.dart';
import 'package:provider/provider.dart';

import 'features/add_pill.dart';
import 'features/pills_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    var pills = PillsRepository().fetchPills(
        emailAddress: Provider.of<User>(context).emailAddress.toString());

    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            _greetingHead(firstName: user.firstName.toString()),
            _greetingSubHead(),
            _subHeading(title: 'Pills'),
            _pillsCarousel(future: pills, userDetails: user),
            _subHeading(title: 'Latest Health Stats'),
            _healthStatCard(reading: '160/232', unit: 'mg/L'),
            _healthStatCard(reading: '233/534', unit: 'cm/A'),
            _healthStatCard(reading: '300', unit: 'BPM'),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          tooltip: 'Show Reports',
          icon: Icon(
            Icons.padding_outlined,
            size: 32,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReportsPage()));
          },
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            tooltip: 'Show graphs',
            icon: Icon(
              Icons.bar_chart_rounded,
              size: 36,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GraphPage()));
            },
          ),
        )
      ],
      title: Center(child: Text(APP_NAME)),
    );
  }

  Widget _greetingHead({required firstName}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        'Welcome back ' + firstName + ',',
        style: TextStyle(fontSize: 26),
      ),
    );
  }

  Widget _greetingSubHead() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text('How are you feeling today?',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
    );
  }

  Widget _subHeading({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 16, bottom: 8),
      child: Text('$title',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
    );
  }

  Widget pillsCard({medName, time}) {
    var hours = int.parse(time.split(':')[0]);
    var minutes = time.split(':')[1];
    var timeFrame;
    var convertedHours;
    if (hours > 12) {
      convertedHours = hours - 12;
      timeFrame = 'PM';
    } else {
      convertedHours = hours;
      timeFrame = 'AM';
    }

    // print('time frame - ' + timeFrame.toString());
    return Container(
      width: 300,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(16),
            child: Text(
              '$medName',
              style: TextStyle(fontSize: 22),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 7, right: 3),
                  child: Icon(
                    Icons.alarm,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '$convertedHours:$minutes $timeFrame',
                  style: TextStyle(fontSize: 35),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget addPillCard({required userDetails}) {
    return Hero(
      tag: 'addPill',
      child: Container(
        margin: EdgeInsets.only(left: 12, right: 16, bottom: 3, top: 3),
        width: 110,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade700,
              blurRadius: 8,
            ),
          ],
          color: Colors.white,
        ),
        child: IconButton(
          icon: Icon(
            Icons.add,
            size: 60,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Provider<User>(
                  create: (context) => userDetails,
                  child: AddPill(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _pillsCarousel({required future, required userDetails}) {
    return SizedBox(
      height: 160.0,
      child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var pills = snapshot.data as List<Pills>;
              return ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: pills.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Card(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PillDetails(
                                          pill: pills[index],
                                        )));
                          },
                          child: pillsCard(
                            medName: pills[index].pillName,
                            time: pills[index].pillTime,
                          ),
                        ),
                      ),
                    ),
                  ),
                  addPillCard(userDetails: userDetails),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return Text('Nothing Returned');
            }
          }),
    );
  }

  Widget _healthStatCard({required reading, required unit}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 8,
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.local_gas_station_outlined,
              size: 40,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 30),
            child: Text(
              '$reading $unit',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
