// RF16 Visualizar todas las charolas registradas en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF16
// RF10 Consultar información detallada de una charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF10
// RF8 Eliminar Charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF8
// RF5 Registrar una nueva charola en el sistema - https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF5
//RF15  Filtrar charola por fecha - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/rf15/

import 'package:zuustento_tracker/data/models/charolaModel.dart';

/// Contrato abstracto que define la comunicación con la API para charolas.
abstract class CharolaAPIService {
  /// Obtiene las charolas paginadas desde el backend.
  ///
  /// [pag] es la página actual, [limite] la cantidad de elementos por página,
  /// y [estado] filtra por charolas activas o pasadas.
  Future<Map<String, dynamic>?> obtenerCharolasPaginadas(int pag, int limite, {String estado});

  Future<CharolaDetalle> obtenerCharola(int id);

  Future<void> eliminarCharola(int id);

  /// Registra una nueva charola en el sistema.
  ///
  /// [charola] es la instancia de [CharolaRegistro] con los datos necesarios.
  Future<Map<String, dynamic>> registrarCharola(CharolaRegistro charola);
  /// Filtra las charolas por fecha de creación.
  /// 
  /// [fechaInicio] y [fechaFin] definen el rango de fechas.
  Future<List<CharolaTarjeta>> filtrarCharolasPorFecha(String fechaInicio, String fechaFin);
  }
