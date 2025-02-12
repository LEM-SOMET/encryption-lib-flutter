import 'dart:convert';
import 'dart:math';

import 'package:cnb_local_database/local_service/local_service.dart';
import 'package:example/model/user_model.dart';
import 'package:example/util/local_source.dart';
import 'package:flutter/material.dart';

class InputView extends StatefulWidget {
  const InputView({super.key});

  @override
  State<InputView> createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  //
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("Input Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.6),
                hintText: "User Name",
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.6),
                hintText: "Email address",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text(
                'Save to hive box',
              ),
              onPressed: () async {
                Random random = Random();
                int randomNumber = random.nextInt(500);
                final userModel = UserModel(
                    id: "$randomNumber",
                    user: usernameController.text.toString(),
                    position: emailController.text.toString());
                try {
                  var jsonData = jsonEncode(userModel);
                  await HiveCNBLocalService()
                      .saveCNBHiveBox(LocalSource.USER_BOX, jsonData);
                } catch (e) {
                  print("Error Exceptions-------- $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
