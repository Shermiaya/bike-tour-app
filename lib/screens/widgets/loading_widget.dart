import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({ Key? key, required this.loading_text}) : super(key: key);
  final String loading_text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child : Text(loading_text, 
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
                ),
              color: STANDARD_COLOR,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            ),
            Container(
              child : CircularProgressIndicator(
                backgroundColor: STANDARD_COLOR,
              ),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            ),
          ],)
      )
    );
  }
}