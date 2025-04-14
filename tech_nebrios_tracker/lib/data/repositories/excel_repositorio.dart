//lib/data/repositories/excel_repositorio.dart
import '../../domain/excel.dart';
import '../services/excel_api_servicio.dart';

class RepositorioExcelImpl implements ExcelRepositorio {
  final ExcelApiServico api;

  RepositorioExcelImpl(this.api);

  @override
  Future<String> descargarExcel() {
    return api.descargarExcel();
  }
}
