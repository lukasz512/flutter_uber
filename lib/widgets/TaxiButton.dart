import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../brand_colors.dart';

class TaxiButton extends StatelessWidget {

  final String title;
  final Color color;
  final Function onPressed;

  const TaxiButton(this.title, this.color, this.onPressed);


  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
      ),
      color: color,
      textColor: Colors.white,
      onPressed: () => onPressed(),
      child: SizedBox(
        height: 50,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontFamily: 'Brand-Bold'),
          ),
        ),
      ),
    );
  }
}
