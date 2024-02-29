import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetupWizard extends StatelessWidget {
  final void Function() completeSetup;

  const SetupWizard(this.completeSetup,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const SizedBox(height: 20),
            const Text(
              'Welcome to SCBSSS!',
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: completeSetup,
              child: const Icon(CupertinoIcons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}