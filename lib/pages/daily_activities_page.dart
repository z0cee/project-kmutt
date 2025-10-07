import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import 'widgets/add_task_dialog.dart';   // ✅ แก้ import ให้ตรง

class DailyActivitiesPage extends StatefulWidget {
  const DailyActivitiesPage({super.key});

  @override
  State<DailyActivitiesPage> createState() => _DailyActivitiesPageState();
}

class _DailyActivitiesPageState extends State<DailyActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("กิจกรรมประจำวัน")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("การแจ้งเตือน 1 ครั้งต่อวัน"),
            subtitle: const Text("เลือกเวลา + แจ้งเตือนซ้ำทุกวัน"),
            onTap: () async {
              final result = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (_) => const AddTaskDialog(isInterval: false), // ✅ dialog เจอแล้ว
              );
              if (result != null) {
                final task = {
                  "id": DateTime.now().millisecondsSinceEpoch,
                  "title": result["title"],
                  "hour": result["hour"],
                  "minute": result["minute"],
                };
                await StorageService.saveDailyTask(task);
                await NotificationService.scheduleDailyOnceWithPreAlerts(task); // ✅ ใช้ชื่อ method ที่มีจริง
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("บันทึกกิจกรรมประจำวันเรียบร้อย")),
                  );
                }
              }
            },
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text("การแจ้งเตือนหลายครั้ง (ทุก X นาที)"),
            subtitle: const Text("ตั้งข้อความ + แจ้งทุก X นาที ใน 24 ชั่วโมงถัดไป"),
            onTap: () async {
              final result = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (_) => const AddTaskDialog(isInterval: true),
              );
              if (result != null) {
                final task = {
                  "id": DateTime.now().millisecondsSinceEpoch,
                  "title": result["title"],
                  "minutes": result["minutes"],
                };
                await StorageService.saveIntervalTask(task);
                await NotificationService.scheduleIntervalForNext24h(task);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("บันทึกกิจกรรมแบบรอบเวลาเรียบร้อย")),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
