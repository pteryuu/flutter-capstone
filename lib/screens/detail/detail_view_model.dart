import 'package:flutter/material.dart';
import 'package:flutter_capstone/model/home/home_model.dart';
import 'package:flutter_capstone/services/detail/detail_service.dart';

class DetailViewModel extends ChangeNotifier {
  /// Data Propertynya sama seperti OfficeModel
  /// sehingga DetailViewModel tidak perlu karena
  /// generate rating hanya sekali, tidak boleh double agar rating tidak terus berubah"
  ///
  Office? _detailOffice;

  Office? get detailData => _detailOffice;

  Future<void> getOfficeDetail(int? id) async {
    try {
      final response = await DetailService.getDetail(id);

      if (response.statusCode == 200) {
        final responseData = response.data['data'];
        _detailOffice = Office.fromJson(responseData);
        notifyListeners();
      } else {
        throw Exception(
            'Gagal memuat detail office. Error code : ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Gagal memuat detail office : $error');
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  int? _index;
  int get getIndex => _index!;

  setIndex(int val) {
    _index = val;
    notifyListeners();
  }

  //Detail Card
  DateTime now = DateTime.now();
  bool isOpen = false;
  void checkOpeningStatus(String open, String close) {
    if (now.isAfter(
          formatRangeIsOpen(open),
        ) &&
        now.isBefore(
          formatRangeIsOpen(close),
        )) {
      isOpen = true;
      notifyListeners();
    } else {
      isOpen = false;
      notifyListeners();
    }
  }

  DateTime formatRangeIsOpen(String value) {
    List<String> timeParts = value.split(':');
    int valueHour = int.parse(timeParts[0]);
    int valueMinute = int.parse(timeParts[1]);
    int valueSecond = int.parse(timeParts[2]);
    return DateTime(
      now.year,
      now.month,
      now.day,
      valueHour,
      valueMinute,
      valueSecond,
      now.millisecond,
    );
  }
}
