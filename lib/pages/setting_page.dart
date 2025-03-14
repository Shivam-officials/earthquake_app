import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setting Page")),
      body: Consumer<AppDataProvider>(
        builder:
            (context, provider, child) => ListView(
              children: [
                Text(
                  "Time Setting",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "Start Date",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(provider.startTime),
                        trailing: IconButton(
                          onPressed: () async {
                            final dt = await selectDate();
                            if (dt != null) {
                              provider.setStartDate(dt);
                            }
                          },
                          icon: Icon(Icons.calendar_month),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "End Date",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(provider.endTime),
                        trailing: IconButton(
                          onPressed: () async {
                            final dt = await selectDate();
                            if (dt != null) {
                              provider.setEndDate(dt);
                            }
                          },
                          icon: Icon(Icons.calendar_month),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          provider.getEarthquakeData();
                        },
                        child: const Text("Fetch According to Updated time"),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Location Setting",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Card(
                  child: SwitchListTile(
                    value: provider.shouldUseLocation,
                    title: Text(
                      provider.currentCity ?? "Your Location is Unknown ",
                    ),
                    subtitle:
                        provider.currentCity == null
                            ? Text("Enable your location first")
                            : Text(
                              'Earthquake data wilt be shown within ${provider.maxRadiusKm} km radius from ${provider.currentCity}',
                            ),
                    onChanged: (value) async{
                      EasyLoading.show(status: "Getting current location...");
                      provider.setLocation(value);
                      EasyLoading.dismiss();
                    },
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Future<DateTime?> selectDate() async {
    final dt = await showDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      context: context,
    );

    if (dt != null) {
      return dt;
    }
    return null;
  }
}
