import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzin/app/services/api_service.dart';

class ActivityLogController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final isFetchingActivities = false.obs;
  final activities = <Map<String, dynamic>>[].obs;
  final hasActivitiesError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    isFetchingActivities.value = true;
    hasActivitiesError.value = false;

    try {
      final response = await _apiService.dio
          .get('/profile/activities')
          .timeout(const Duration(seconds: 8));
      
      final data = response.data;
      if (data is Map && data['activities'] is List) {
        activities.assignAll(data['activities'].cast<Map<String, dynamic>>());
      } else {
        activities.clear();
      }
    } catch (e) {
      hasActivitiesError.value = true;
      debugPrint('Error fetching activities: $e');
    } finally {
      isFetchingActivities.value = false;
    }
  }
}
