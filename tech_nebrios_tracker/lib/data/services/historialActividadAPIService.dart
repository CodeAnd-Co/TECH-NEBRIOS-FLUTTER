import '../models/historialActividadModel.dart';

abstract class HistorialActividadAPIService {
  Future<HistorialactividadRespuesta?> historialActividad(charolaId);
}