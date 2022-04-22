// Import Stuf //
import 'dart:convert';
import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;
import 'package:t4gopengov/GovData.dart';
import 'home_screen.dart';

// Main Function
void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), //we could imagine more sides/ screen
    ));
