import 'package:flutter/material.dart';
import 'package:knu_helper/all/model/package.dart';

/// flutter pub run flutter_oss_licenses:generate.dart -o asset/json/licenses.json --json
class OpensourceItem extends StatelessWidget {
  final Package package;

  const OpensourceItem(this.package, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 40,
        bottom: 30,
      ),
      color: Colors.white70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(package.name),
          //package.name.text.size(20).bold.make().pOnly(left:20, bottom: 8),
          Text(package.description),
          if (package.authors.isNotEmpty)
            Text(package.authors.join(", ")),
          if (package.homepage!=null)
            Text(package.homepage ?? ""),
          Container(
            decoration: BoxDecoration(
              color: Colors.white60,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            margin: const EdgeInsets.only(left: 20, top: 15, right: 20),
            height: 230,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(package.license ?? ""),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
