import 'package:flutter/material.dart';
import 'package:practical_test/core/strings.dart';
import '../../core/app_color.dart';
import '../widgets/circular_icon_button.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

var signature;

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
            child: Icon(Icons.arrow_back, color: Colors.white,)),
        backgroundColor: AppColor.primaryColor,
        title: Text(
          appStrings.signature,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Material(
              elevation: 2,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: 200,
                child: Signature(
                  controller: _controller,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularIconButton(
                icon: Icons.refresh,
                onTap: () {
                  _controller.clear();
                },
              ),
              CircularIconButton(
                icon: Icons.done,
                onTap: () async {
                  if (_controller.isNotEmpty) {
                    signature = await _controller.toPngBytes();
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
