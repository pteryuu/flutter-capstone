import 'package:flutter/material.dart';
import 'package:flutter_capstone/services/reschedule/reschedule_service.dart';

class RescheduleModelView extends ChangeNotifier {
  Future<void> updateRecheduleOffice(int id, String start, String end) async {
    final response =
        await RescheduleService().updateTransactionSchedule(id, start, end);
    if (response.statusCode == 201) {
      print('Schedule Office successfully updated.');
    } else {
      print(
          'Failed to update Schedule Office. Error: ${response.statusMessage}');
    }
  }
}
