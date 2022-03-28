import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bike_tour_app/screens/wrapper.dart';
import 'package:bike_tour_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:bike_tour_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'valid_regex.dart';
void main() {
  test('Empty email test', () {
    var emptyInput = ' ';

    var result = ValidRegex().getValidEmailRegExp().hasMatch(emptyInput);

    expect(result, false);
  });

  
  test('Given empty password input', () async {
    var emptyInput = ' ';

    var result = ValidRegex().getValidPasswordRegExp().hasMatch(emptyInput);

    expect(result, false);
  });

  
  test('Given valid email address', () async {
    var result = ValidRegex().getValidEmailRegExp().hasMatch('JohnDoe1@example.com');

    expect(result, true);
  });

  
  test('Given valid Password', () {  
    var result = ValidRegex().getValidPasswordRegExp().hasMatch('Qwerty13!');

    expect(result, true);
  });

  
  test('Given invalid Email', (){
     var result = ValidRegex().getValidEmailRegExp().hasMatch('JohnDoe1example.com');

    expect(result, false);
  });

  
  test('Given invalid Password', () {
    var result = ValidRegex().getValidPasswordRegExp().hasMatch('happy');

    expect(result, false);
  });

}
