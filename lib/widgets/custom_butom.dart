import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButom extends StatelessWidget {
  CustomButom({this.onTap,required this.Textt});
  String? Textt;
VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  width: double.infinity,
                  height: 65,
                  child:  Center(
                    child: Text(
                      Textt!,
                      style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
    );
  }
}