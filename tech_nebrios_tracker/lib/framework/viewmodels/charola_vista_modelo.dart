import 'package:flutter/material.dart';
import '../../data/models/charola_modelo.dart';
import '../../domain/get_charolas_paginacion_casousuario.dart';

class CharolaVistaModelo extends ChangeNotifier {
  final GetCharolasPaginacionCasousuario getCharolasUseCase;

  CharolaVistaModelo({GetCharolasPaginacionCasousuario? useCase})
      : getCharolasUseCase = useCase ?? GetCharolasCasoUsoImpl();

  List<Charola> charolas = [];
  int currentPage = 1;
  final int limit = 12;
  bool isLoading = false;
  bool hasMore = true;
  int totalPages = 1;

  Future<void> loadCharolas({bool refresh = false}) async {
    if (isLoading) return;

    if (refresh) {
      charolas.clear();
      hasMore = true;
    }

    isLoading = true;
    notifyListeners();

    print("🔗 ViewModel intenta cargar charolas desde la API (page: $currentPage, limit: $limit)");

    final response = await getCharolasUseCase.execute(page: currentPage, limit: limit);

    if (response != null) {
      charolas.addAll(response.data);
      totalPages = response.totalPages; 
      hasMore = currentPage < totalPages;
    }

    isLoading = false;
    notifyListeners();
  }

  void cargarPaginaAnterior() {
  if (currentPage > 1) {
    currentPage--;
    loadCharolas(refresh: true); // limpiar antes de cargar
  }
}

void cargarPaginaSiguiente() {
  if (currentPage < totalPages) {
    currentPage++;
    loadCharolas(refresh: true); 
  }
}

}
