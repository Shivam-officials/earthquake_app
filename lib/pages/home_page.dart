import 'dart:ui';

import 'package:earthquake_app/pages/setting_page.dart';
import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        actions: [
          IconButton(onPressed: _showSortingDialog, icon: Icon(Icons.sort)),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingPage()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Consumer<AppDataProvider>(
          builder: (BuildContext context, provider, Widget? child) {
            if (provider.earthquakeModel == null) {
              return CircularProgressIndicator();
            } else if (provider.earthquakeModel!.features!.isEmpty) {
              return Text('No data');
            }
            return ListView.builder(
              itemCount: provider.earthquakeModel?.features?.length,
              itemBuilder: (context, index) {
                final data =
                    provider.earthquakeModel?.features?[index].properties;
                return ListTile(
                  title: Text(data!.place ?? data.title ?? "Unknown"),
                  subtitle: Text(
                    getFormattedDateTime(data.time!, 'EEE MMM dd yyyy hh:mm a'),
                  ),
                  trailing: Chip(
                    label: Text(data.mag.toString()),
                    avatar:
                        data.alert == null
                            ? null
                            : CircleAvatar(
                              backgroundColor: provider.getAlertColor(
                                data.alert!,
                              ),
                            ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    context.read<AppDataProvider>().init();
    super.didChangeDependencies();
  }

  void _showSortingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sort by'),
          content: Consumer<AppDataProvider>(
            builder:
                (context, provider, child) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioGroup(
                      value: 'magnitude',
                      groupValue: provider.orderBy,
                      label: 'Magnitude-Desc',
                      onChanged: (value) {
                        provider.setOrder(value!);
                        Navigator.pop(context);
                      },
                    ),
                    RadioGroup(
                      value: 'magnitude-asc',
                      groupValue: provider.orderBy,
                      label: 'Magnitude-Asc',
                      onChanged: (value) {
                        provider.setOrder(value!);
                        Navigator.pop(context);
                      },
                    ),
                    RadioGroup(
                      value: 'time',
                      groupValue: provider.orderBy,
                      label: 'time-Desc',
                      onChanged: (value) {
                        provider.setOrder(value!);
                        Navigator.pop(context);
                      },
                    ),
                    RadioGroup(
                      value: 'time-asc',
                      groupValue: provider.orderBy,
                      label: 'Time-Asc',
                      onChanged: (value) {
                        provider.setOrder(value!);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class RadioGroup extends StatelessWidget {
  final String value;

  final String groupValue;
  final String label;
  final Function(String?) onChanged;

  const RadioGroup({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}
