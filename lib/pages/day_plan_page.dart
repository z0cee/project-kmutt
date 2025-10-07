

import 'package:flutter/material.dart';

class DayPlanPage extends StatelessWidget {
  final DateTime? date;

  const DayPlanPage({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "แผนสำหรับวันที่ ${date != null ? "${date!.day}/${date!.month}/${date!.year}" : "-"}",
        ),
      ),
      body: Center(
        child: Text(
          date != null
              ? "นี่คือกิจกรรมสำหรับวันที่ ${date!.day}/${date!.month}/${date!.year}"
              : "ยังไม่ได้เลือกวันที่",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
