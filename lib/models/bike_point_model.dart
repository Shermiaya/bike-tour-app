// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class BikePointModel {
  final id;
  final commonName;

  final NbBikes;
  final NbEmptyDocks;
  final NbDocks;

  const BikePointModel({
    required this.id,
    required this.commonName,
    required this.NbBikes,
    required this.NbEmptyDocks,
    required this.NbDocks,
  });

  factory BikePointModel.fromJson(Map<String, dynamic> json) {
    return BikePointModel(
      id: json['id'],
      commonName: json['commonName'],
      NbBikes: json['additionalProperties'][6]['value'],
      NbEmptyDocks: json['additionalProperties'][7]['value'],
      NbDocks: json['additionalProperties'][8]['value'],
    );
  }
}