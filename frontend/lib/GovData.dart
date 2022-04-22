import 'dart:html';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

class GovData {
  late String department; //Values of the Json File ? -> Nullcase
  late int datasets;

  GovData(this.department, this.datasets); //constructor

  GovData.fromJson(Map<String, dynamic> json) {
    //Data from Json mapped in a String
    department = json['department'];
    datasets = json['datasets'];
  }
}
