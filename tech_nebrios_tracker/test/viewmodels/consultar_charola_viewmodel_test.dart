import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_nebrios_tracker/data/models/charola_model.dart';
import 'package:tech_nebrios_tracker/framework/viewmodels/consultar_charola_viewmodel.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late MockObtenerCharolaUseCase mockUseCase;
  late CharolaViewModel viewModel;

  setUp(() {
    mockUseCase = MockObtenerCharolaUseCase();
    viewModel = CharolaViewModel(mockUseCase);
  });

  test('carga exitosa de charola', () async {
    final fakeCharola = Charola(
      charolaId: 1011,
      nombreCharola: 'EQUIDDE',
      comidaOtorgada: 15,
      hidratacionOtorgada: 1,
      comidaCiclo: 15,
      hidratacionCiclo: 1,
      fechaActualizacion: 'desconocido',
      estado: 'activa',
      densidadLarva: 10,
      fechaCreacion: '2025-04-30T06:00:00.000Z',
      pesoCharola: 15,
      comidaNombre: 'Cereza',
      comidaDesc: 'Fruta roja dulce',
      hidratacionNombre: 'Zanahoria',
      hidratacionDesc: 'Vegetal'
    );

    when(mockUseCase.obtenerCharola(1011))
        .thenAnswer((_) async => fakeCharola);

    await viewModel.cargarCharola(1011);

    print('Charola obtenida: ${viewModel.charola?.nombreCharola}');

    expect(viewModel.charola, isNotNull);
    expect(viewModel.charola!.nombreCharola, 'EQUIDDE');
    expect(viewModel.charola!.comidaNombre, 'Cereza');
    expect(viewModel.charola!.hidratacionNombre, 'Zanahoria');
    expect(viewModel.cargando, false);
  });

  test('carga con error lanza excepción y charola queda null', () async {
    when(mockUseCase.obtenerCharola(1011))
        .thenThrow(Exception('Error al obtener la charola'));

    await viewModel.cargarCharola(1011);

    expect(viewModel.charola, isNull);
    expect(viewModel.cargando, false);

    print('Charola obtenida: ${viewModel.charola?.nombreCharola}');
  });
}
