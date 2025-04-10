import '../../data/services/api_service.dart';

class TestViewModel {
  final ApiService _apiService = ApiService();

  Future<String> fetchMessage() async {
    return await _apiService.getTest();
  }
}
