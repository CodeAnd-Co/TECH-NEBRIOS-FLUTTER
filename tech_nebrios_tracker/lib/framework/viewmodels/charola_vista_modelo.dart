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

    final response = await getCharolasUseCase.execute(page: currentPage, limit: limit);
    print('Cargando página: $currentPage');
    print('Charolas recibidas: ${response?.data.length}');


    if (response != null) {
      charolas.addAll(response.data);
      hasMore = currentPage < response.totalPages;
      currentPage++;
    }

    isLoading = false;
    notifyListeners();
  }
}
