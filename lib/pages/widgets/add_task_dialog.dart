import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  final bool isInterval;
  const AddTaskDialog({super.key, required this.isInterval});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  TimeOfDay? _time;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isInterval ? "ตั้งกิจกรรมแบบรอบเวลา" : "ตั้งกิจกรรม 1 ครั้งต่อวัน"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "ข้อความแจ้งเตือน"),
          ),
          const SizedBox(height: 10),
          if (widget.isInterval)
            TextField(
              controller: _minutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "ทุกกี่นาที"),
            )
          else
            ElevatedButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() => _time = picked);
                }
              },
              child: Text(_time == null
                  ? "เลือกเวลา"
                  : "เวลา: ${_time!.hour}:${_time!.minute.toString().padLeft(2, '0')}"),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("ยกเลิก"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isEmpty) return;
            if (widget.isInterval) {
              Navigator.pop(context, {
                "title": _titleController.text,
                "minutes": int.tryParse(_minutesController.text) ?? 60,
              });
            } else {
              Navigator.pop(context, {
                "title": _titleController.text,
                "hour": _time?.hour ?? TimeOfDay.now().hour,
                "minute": _time?.minute ?? TimeOfDay.now().minute,
              });
            }
          },
          child: const Text("บันทึก"),
        ),
      ],
    );
  }
}
