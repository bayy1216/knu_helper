import 'package:flutter/material.dart';

class DataUtils{
  static String dateTimeToString(DateTime date){
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static int stringToColorCode(String value){
    return int.parse('FF$value', radix: 16);
  }
  static String colorToHexCode(Color color){
    return color.value.toRadixString(16).substring(2).toUpperCase();
  }


}