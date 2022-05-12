import 'package:cab_rider/brand_colors.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String status;

  ProgressDialog({required this.status});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 5,
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(BrandColors.colorAccent),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(status, style: const TextStyle(fontSize: 15),)
            ],
          ),
        ),
      ),
    );
  }
}
