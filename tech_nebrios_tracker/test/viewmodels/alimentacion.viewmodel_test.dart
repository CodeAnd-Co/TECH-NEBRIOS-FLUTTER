import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_nebrios_tracker/framework/viewmodels/alimentacion_viewmodel.dart';
import 'package:tech_nebrios_tracker/data/models/alimentacion_model.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late MockAlimentoRepository mockRepo;
  late MockEditarAlimentoCasoUso mockEditar;
  late AlimentacionViewModel vm;

  setUp(() {
    mockRepo = MockAlimentoRepository();
    mockEditar = MockEditarAlimentoCasoUso();
    vm = AlimentacionViewModel(
      repo: mockRepo,
      editarCasoUso: mockEditar,
    );
  });

  group('cargarAlimentos', () {
    test('✅ carga exitosa actualiza lista y notifica', () async {
      final lista = [
        Alimento(
          idAlimento: 1,
          nombreAlimento: 'Manzana',
          descripcionAlimento: 'Fruta roja',
        )
      ];
      // Simula que repo devuelve datos
      when(mockRepo.obtenerAlimentos()).thenAnswer((_) async => lista);

      // Capturar notificaciones de cambio de isLoading
      final notifications = <bool>[];
      vm.addListener(() {
        notifications.add(vm.isLoading);
      });

      await vm.cargarAlimentos();

      // Verificaciones de estado
      expect(vm.alimentos, equals(lista));
      expect(vm.error, isNull);
      expect(vm.isLoading, isFalse);

      // Debe notificar dos veces: true al iniciar y false al terminar
      expect(notifications, [true, false]);
    });

    test('❌ error en repo setea mensaje de error', () async {
      when(mockRepo.obtenerAlimentos()).thenThrow(Exception('boom'));

      await vm.cargarAlimentos();

      expect(vm.alimentos, isEmpty);
      expect(vm.error, contains('Error al cargar alimentos'));
      expect(vm.isLoading, isFalse);
    });
  });

  group('editarAlimento', () {
    final valido = Alimento(
      idAlimento: 2,
      nombreAlimento: 'Pera',
      descripcionAlimento: 'Fruta verde',
    );

    test('❌ valida nombre vacío', () async {
      final bad = Alimento(
        idAlimento: valido.idAlimento,
        nombreAlimento: '  ',
        descripcionAlimento: valido.descripcionAlimento,
      );
      final res = await vm.editarAlimento(bad);
      expect(res, 'Nombre y descripción no pueden estar vacíos.');
    });

    test('❌ valida descripción vacía', () async {
      final bad = Alimento(
        idAlimento: valido.idAlimento,
        nombreAlimento: valido.nombreAlimento,
        descripcionAlimento: '',
      );
      final res = await vm.editarAlimento(bad);
      expect(res, 'Nombre y descripción no pueden estar vacíos.');
    });

    test('❌ valida nombre con números', () async {
      final bad = Alimento(
        idAlimento: valido.idAlimento,
        nombreAlimento: 'Fresa1',
        descripcionAlimento: valido.descripcionAlimento,
      );
      final res = await vm.editarAlimento(bad);
      expect(res, 'El nombre no debe contener números.');
    });

    test('✅ edición exitosa recarga lista y retorna null', () async {
      when(mockEditar.editar(alimento: valido)).thenAnswer((_) async {});
      when(mockRepo.obtenerAlimentos()).thenAnswer((_) async => [valido]);

      final res = await vm.editarAlimento(valido);

      expect(res, isNull);
      expect(vm.alimentos, [valido]);
    });

    test('❌ maneja error 400 como Datos no válidos', () async {
      when(mockEditar.editar(alimento: valido))
          .thenThrow(Exception('400 Bad Request'));

      final res = await vm.editarAlimento(valido);
      expect(res, '❌ Datos no válidos.');
    });

    test('❌ maneja error 101 como Sin conexión a internet', () async {
      when(mockEditar.editar(alimento: valido))
          .thenThrow(Exception('101 Switching Protocols'));

      final res = await vm.editarAlimento(valido);
      expect(res, '❌ Sin conexión a internet.');
    });

    test('❌ maneja error 500 como Error del servidor', () async {
      when(mockEditar.editar(alimento: valido))
          .thenThrow(Exception('500 Internal Server Error'));

      final res = await vm.editarAlimento(valido);
      expect(res, '❌ Error del servidor.');
    });

    test('❌ maneja otros errores como Error desconocido', () async {
      when(mockEditar.editar(alimento: valido))
          .thenThrow(Exception('XYZ Unexpected'));

      final res = await vm.editarAlimento(valido);
      expect(res, '❌ Error desconocido.');
    });
  });
}
