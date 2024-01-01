import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knu_helper/common/layout/default_layout.dart';

import '../component/opensource_item.dart';
import '../model/package.dart';

class OpensourceScreen extends StatefulWidget {
  static String get routeName => 'opensource';

  const OpensourceScreen({super.key});

  @override
  State<OpensourceScreen> createState() => _OpensourceScreenState();
}

class _OpensourceScreenState extends State<OpensourceScreen> {
  List<Package> packageList = [];

  @override
  void initState() {
    initData();
    super.initState();
  }



  Future<List<Package>> getObjectList(String filePath) async {
    final string = await rootBundle.loadString(filePath);
    final json = jsonDecode(string);
    if(json is !List){
      print("json is not List");
    }else{
      List<Package> list = [];
      print(json[0].runtimeType);
      for(var i = 0; i < json.length; i++){
        if(json[i] is Map<String, dynamic>) {
          final x= Package.fromJson(json[i] as Map<String, dynamic>);
          list.add(x);
        }

      }
      print(json[1].runtimeType);
      return list;
    }
    return [];
  }

  void initData() async {
    final list = await getObjectList("asset/json/licenses.json");
    setState(() {
      packageList = list;
    });
    print(list.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'opensource',
      elevation: 2,
      body: ListView.separated(
        itemBuilder: (context, index) => OpensourceItem(packageList[index]),
        itemCount: packageList.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );

  }
}
