import 'dart:convert';
import 'dart:developer';

import 'package:cnb_local_database/cnb_local_database.dart';
import 'package:example/model/user_model.dart';
import 'package:example/util/local_source.dart';
import 'package:example/view/input_view.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listing Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyListView(),
    );
  }
}

class MyListView extends StatefulWidget {
  const MyListView({super.key});

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  List<UserModel> list = [];

  @override
  void initState() {
    super.initState();
    _getAllBoxValues();
  }

  void _getAllBoxValues() async {
    final user =
        await HiveCNBLocalService().retrieveCNBHiveBox(LocalSource.USER_BOX);
    setState(() {
      list = [];
      try {
        for (var value in user) {
          var data = UserModel.fromJson(jsonDecode(value));
          setState(() {
            list.add(data);
          });
        }
      } catch (e) {
        log("Error Exceptions-------- $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // _getAllBoxValues();
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Hive Data"),
        actions: [
          IconButton(
            onPressed: () async {
              await HiveCNBLocalService().clearCNBHiveBox(LocalSource.USER_BOX);
              setState(() {});
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(list[index].user.toString()),
              subtitle: Text(list[index].position),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const InputView(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
