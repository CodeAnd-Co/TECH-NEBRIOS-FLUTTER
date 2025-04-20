import 'package:flutter/material.dart';
import '../../data/models/charola_modelo.dart';
import '../../domain/get_charolas_paginacion_casousuario.dart';

class CharolaViewModel extends ChangeNotifier {
  final GetCharolasUseCase getCharolasUseCase;

  CharolaViewModel({GetCharolasUseCase? useCase})
      : getCharolasUseCase = useCase ?? GetCharolasUseCaseImpl();

  List<Charola> charolas = [];
  int currentPage = 1;
  final int limit = 10;
  bool isLoading = false;
  bool hasMore = true;

  Future<void> loadCharolas({bool refresh = false}) async {
    if (isLoading) return;

    if (refresh) {
      currentPage = 1;
      charolas.clear();
      hasMore = true;
    }

    isLoading = true;
    notifyListeners();

    print("🔗 ViewModel intenta cargar charolas desde la API (page: $currentPage, limit: $limit)");

    final response = await getCharolasUseCase.execute(page: currentPage, limit: limit);

    if (response != null) {
      charolas.addAll(response.data);
      hasMore = currentPage < response.totalPages;
      currentPage++;
    }

    isLoading = false;
    notifyListeners();
  }
}
