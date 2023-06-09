import 'package:dio/dio.dart';
import 'package:flutter_capstone/core/init/const/api.dart';
import 'package:flutter_capstone/model/home/home_model.dart';
import 'package:flutter_capstone/model/order/history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_capstone/services/home/home_services.dart';

class HistoryService {
  final Dio _dio = Dio();
  HomeService homeService = HomeService();

  Future<List<Office>> fetchOfficeData() async {
    try {
      final response = await homeService.fetchHomeData();
      return response;
    } catch (error) {
      throw Exception('Failed to fetch office data: $error');
    }
  }

  Future<List<History>> fetchHistoryData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    try {
      final officeData = await fetchOfficeData();

      final response = await _dio.get('$baseUrl/api/v1/transaction/history',
          options: Options(headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        print(responseData); // Log the response data for debugging

        HistoryModel history = HistoryModel.fromJson(responseData);
        if (history.data.isEmpty) {
          return [];
        }
        return history.data;
      } else {
        throw Exception(
            'Failed to fetch history data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch history data: $error');
    }
  }
}
