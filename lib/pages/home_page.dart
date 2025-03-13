import 'dart:ui';

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
      appBar: AppBar(title: Text('Home page')),
      body: Center(
        child: Consumer<AppDataProvider>(
            builder:
                (BuildContext context, provider, Widget? child) {
              if (provider.earthquakeModel == null) {
                return CircularProgressIndicator();
              } else if (provider.earthquakeModel!.features!.isEmpty) {
                return Text('No data');
              }
              return ListView.builder(
                  itemCount: provider.earthquakeModel?.features?.length,
                  itemBuilder: (context, index) {
                    final data = provider.earthquakeModel?.features?[index]
                        .properties;
                    return ListTile(
                      title: Text(data!.place ?? data.title ?? "Unknown"),
                      subtitle: Text(getFormattedDateTime(
                          data.time!, 'EEE MMM dd yyyy hh:mm a')),
                      trailing: Chip(
                        label: Text(data.mag.toString()),
                        avatar: data.alert==null?null:
                        CircleAvatar(
                          backgroundColor: provider.getAlertColor(data.alert!),
                        ),
                      ),
                    );
                  }
              );
            }

        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    context.read<AppDataProvider>().init();
    super.didChangeDependencies();
  }
}
