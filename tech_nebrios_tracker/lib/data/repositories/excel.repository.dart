//lib/data/repositories/excel_repositorio.dart
import '../../domain/excel.dart';
import '../services/excelAPI.service.dart';

class RepositorioExcelImpl implements ExcelRepositorio {
  final ExcelApiServico api;

  RepositorioExcelImpl(this.api);

  @override
  Future<String> descargarExcel() {
    return api.descargarExcel();
  }
}
