import 'dart:ui';

import 'package:earthquake_app/providers/app_data_provider.dart';
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
              (BuildContext context, provider, Widget? child) => Text(
                '${provider.earthquakeModel?.features?.length} are there',
              ),
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
